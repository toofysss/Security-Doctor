using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using SecurityDoctor.DataBase;
using SecurityDoctor.Modles;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
         private readonly ApplicationDbContext _context;
        public NotificationController(ApplicationDbContext db) => _context = db;

        [HttpGet("AllNotification")]
        public ActionResult<IEnumerable<Notification>> GetNotification(int id,int status)
        {
        var notifications = _context.Notification.Where(e => e.userid == id && e.status== status).Select(u => new
            {
                u.id,
                message = EncryptManager.Decrypt(u.message),
                u.userid,
                u.status,
                u.schedule
            }).ToList();
          

            return Ok(notifications);
        }
        [HttpPost("SendMessage")]
        public ActionResult<IEnumerable<Notification>> SendMessage([FromBody] Notification Notification)
        {

            if (Notification == null) return BadRequest();
            var encrypt = EncryptManager.Encrypt(Notification.message);
            Notification.message = encrypt;
            _context.Notification.Add(Notification);
            _context.SaveChanges();
            return Ok();
        }

        [HttpPut("UpdateMessage")]
        public ActionResult<IEnumerable<Notification>> UpdateMessage([FromBody] Notification Notification)
        {
            var notificationID = _context.Notification.FirstOrDefault(e => e.id == Notification.id);
            if (notificationID == null) return NotFound();
       
            notificationID.status = Notification.status;
            _context.Notification.Update(notificationID);
            var scheduleID = _context.Schedule.FirstOrDefault(e => e.id == Notification.schedule);
            scheduleID.status = 0;
            _context.Schedule.Update(scheduleID);
            _context.SaveChanges();
            return Ok();
        }
    }
}
