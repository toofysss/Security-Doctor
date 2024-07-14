using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SecurityDoctor.DataBase;
using SecurityDoctor.Modles;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace SecurityDoctor.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ScheduleController:ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public ScheduleController(ApplicationDbContext db) => _context = db;

        [HttpGet("GetAll")]
        public  async Task< ActionResult<IEnumerable<AdminInfo>>>  GetSchedule(int adminid, int status)
        {
 
            var AdminInfoID = _context.AdminInfo.FirstOrDefault(e => e.userid == adminid);
            var Schedule = await _context.Schedule.Where(e => e.adminid == AdminInfoID.id && e.status == status)
                .Include(p => p.Operation)
                .Select(p => new
                {
                    p.id,
                    patientInfo = _context.PaitentIfno.Where(ai => ai.id == p.patientid).Select(ai => new
                    {
                        ai.id,
                        name = EncryptManager.Decrypt(ai.name),
                        ai.age,
                        address = EncryptManager.Decrypt(ai.address),
                        phone1 = EncryptManager.Decrypt(ai.phone1),
                        phone2 = EncryptManager.Decrypt(ai.phone2),
                        notes = EncryptManager.Decrypt(ai.notes),
                        ai.blood,
                        ai.userid,
                        ai.gender
                    }).FirstOrDefault(),
                    AdminInfo = _context.AdminInfo.Where(ai => ai.id == p.adminid).Select(ai => new
                    {
                        ai.id,
                        name = EncryptManager.Decrypt(ai.name),
                        address = EncryptManager.Decrypt(ai.address),
                        worklocation = EncryptManager.Decrypt(ai.worklocation),
                        workopen = EncryptManager.Decrypt(ai.workopen),
                        workclose = EncryptManager.Decrypt(ai.workclose),
                        phone = EncryptManager.Decrypt(ai.phone),
                        workdays = EncryptManager.Decrypt(ai.workdays),
                        dscrp = EncryptManager.Decrypt(ai.dscrp),
                        depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault(),
                        image = EncryptManager.Decrypt(ai.image),
                        ai.userid,
                    }).FirstOrDefault(),
                    p.status,
                    p.opendate,
                    p.closedate,
                    Operation = p.Operation.Select(op => new
                    {
                        op.id,
                        op.status,
                        notes = EncryptManager.Decrypt(op.notes),
                        answers = EncryptManager.Decrypt(op.answers),
                        OperationAdminInfo = _context.AdminInfo.Where(ai => ai.id == op.usertypeid).Select(ai => new {
                            ai.id,
                            name = EncryptManager.Decrypt(ai.name),
                            image = EncryptManager.Decrypt(ai.image),
                            depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault()

                        }).FirstOrDefault(),
                        OperationImage = op.OperationImage.Where(oi => oi.operationid == op.id).Select(im => new
                        {
                            image = EncryptManager.Decrypt(im.image),
                        }).ToList()
                    }).ToList()
                })
                .ToListAsync();
            if (Schedule == null) return NotFound();
            return Ok(Schedule);
        }
        [HttpPost("Insert")]
        public ActionResult<IEnumerable<Schedule>> AddSchedule([FromBody] Schedule Schedule)
        {
             if (Schedule == null) return BadRequest();
            var paitnetid = _context.PaitentIfno.FirstOrDefault(e => e.userid == Schedule.patientid);
            Schedule.patientid = paitnetid.id;
            _context.Schedule.Add(Schedule);
            _context.SaveChanges();
            return Ok(paitnetid);
        }
        [HttpPut("Update")]
        public ActionResult<IEnumerable<Schedule>> UpdateSchedule([FromBody] Schedule Schedule)
        {
            var ScheduleID = _context.Schedule.FirstOrDefault(u => u.id == Schedule.id);
            if (ScheduleID == null) return BadRequest();
            if (Schedule.status > 0) ScheduleID.status = Schedule.status;
            if (Schedule.closedate !=null) ScheduleID.closedate = Schedule.closedate;
            _context.Schedule.Update(ScheduleID);
            _context.SaveChanges();
            return Ok();
        }

        [HttpPost("ShareFiles")]
        public ActionResult<IEnumerable<Schedule>> ShareFiles([FromBody] Schedule Schedule)
        {

            var ScheduleID = _context.Schedule.FirstOrDefault(u => u.id == Schedule.id);
            if (ScheduleID == null) return BadRequest();
            if (Schedule.status > 0) ScheduleID.status = 1;
            if (Schedule.closedate != null) ScheduleID.closedate = Schedule.closedate;
            _context.Schedule.Update(ScheduleID);

            Schedule.id = 0;
            Schedule.status = 2;
            Schedule.closedate = "";
            _context.Schedule.Add(Schedule);
            _context.SaveChanges();
            var newScheduleId = Schedule.id;
            SendNotificationDevice(Schedule.patientid, newScheduleId);
            return Ok();
        }
         private   void SendNotificationDevice(int paitentinfoid,int schedule)
        {
            var title = "طلب مشاركة ملف الشخصي";
            var body = "يوجد طلب مشاركة بياناتك الشخصية";

            var paiteintInfoID = _context.PaitentIfno.FirstOrDefault(u => u.id == paitentinfoid);
            _ = SendNotification.SendNotificationS(paiteintInfoID.userid, title, body);

            var newNotification = new Notification
            {
                id = 0,
                message = EncryptManager.Encrypt(body),
                userid = paiteintInfoID.userid,
                status = 0,
                schedule = schedule
            };
            _context.Notification.Add(newNotification);
            _context.SaveChanges();
         }

    }
}
