using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SecurityDoctor.DataBase;
using SecurityDoctor.Modles;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OperationController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public OperationController(ApplicationDbContext db) => _context = db;
        [HttpGet("GetAll")]
        public async Task<ActionResult<IEnumerable<Operation>>> GetAllOperation(int adminid, int status,int usertype)
        {
            var AdminInfoID = _context.AdminInfo.FirstOrDefault(e => e.userid == adminid);
            if (AdminInfoID == null) return NotFound();
            var Schedule = await _context.Operation.Where(e => e.adminid == AdminInfoID.id && e.status == status && e.usertypeid ==usertype)
                .Include(p => p.Schedule).Select(p => new
                {
                    p.id,
                    p.scheduleid,
                    p.adminid,
                    p.usertypeid,
                    p.status,
                    notes = EncryptManager.Decrypt(p.notes),
                    answers = EncryptManager.Decrypt(p.answers),
                    patientInfo = _context.PaitentIfno.Where(ai => ai.id == p.Schedule.patientid).Select(ai => new {

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
                })
                .ToListAsync();
            if (Schedule == null) return NotFound();
            return Ok(Schedule);
        }

        [HttpPost("Insert")]
        public ActionResult<IEnumerable<Operation>> InsertOperation(  [FromBody] Operation Operation)
        {
            if (Operation == null) return BadRequest();
            Operation.notes = EncryptManager.Encrypt(Operation.notes);
            Operation.answers = EncryptManager.Encrypt(Operation.answers);
            _context.Operation.Add(Operation);
            _context.SaveChanges();
            return Ok();
        }

        [HttpPut("Update")]
        public async Task<ActionResult<IEnumerable<Operation>>> UpdateOperation(List<IFormFile> operationImg, [FromForm] Operation Operation)
        {

            if (operationImg != null)
            {
                foreach (var operationImageFile in operationImg)
                {
                    var image = await FilesManager.Insertfiles(operationImageFile, "Upload\\OperationImg");
                    var encryptedImage = EncryptManager.Encrypt(image);

                    var operationImage = new OperationImage
                    {
                        operationid = Operation.id,
                        image = encryptedImage
                    };
                    _context.OperationImage.Add(operationImage);
                }
            }

            if (Operation == null) return BadRequest();
            var OperationID = _context.Operation.FirstOrDefault(e => e.id == Operation.id);
            if (OperationID == null) return NotFound();
   
           if(Operation.notes !=null) OperationID.notes = EncryptManager.Encrypt(Operation.notes);
            OperationID.status = 1;
            _context.Operation.Update(OperationID);
            _context.SaveChanges();
            return Ok();
        }

        [HttpGet("GetPatient")]
        public async Task<ActionResult<IEnumerable<Schedule>>> GetpatientOperation(int patientid,int usertype)
        {
            var PaitentIfnoID = _context.PaitentIfno.FirstOrDefault(e => e.userid == patientid);
            if (PaitentIfnoID == null) return NotFound();
            var Schedule = await _context.Schedule.Where(e => e.patientid == PaitentIfnoID.id && e.usertypeid== usertype)
                .Include(p => p.Operation)
                .Select(p => new
                {
                    p.id,
                    patientInfo = _context.PaitentIfno.Where(ai => ai.id == p.patientid).Select(ai => new {
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
                    AdminInfo = _context.AdminInfo.Where(ai => ai.id == p.adminid).Select(ai => new {
                        ai.id,
                        name = EncryptManager.Decrypt(ai.name),
                        image = EncryptManager.Decrypt(ai.image),
                        depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault()

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

                        op.usertypeid,
                        OperationAdminInfo = _context.AdminInfo.Where(ai => ai.id == op.adminid).Select(ai => new {
                            ai.id,
                            name = EncryptManager.Decrypt(ai.name),
                            image = EncryptManager.Decrypt(ai.image),
                            depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault()

                        }).FirstOrDefault(),
                        OperationImage = op.OperationImage.Where(oi => oi.operationid == op.id).Select(im => new {
                            image = EncryptManager.Decrypt(im.image),
                        }).ToList()
                    }).ToList()
                })
                .ToListAsync();
            if (Schedule == null) return NotFound();
            return Ok(Schedule);
        }

        [HttpGet("GetProfile")]
        public async Task<ActionResult<IEnumerable<Schedule>>> GetpatientProfile(int patientid, int usertype)
        {
 
            var Schedule = await _context.Schedule.Where(e => e.patientid == patientid && e.usertypeid == usertype)
                .Include(p => p.Operation)
                .Select(p => new
                {
                    p.id,
                    patientInfo = _context.PaitentIfno.Where(ai => ai.id == p.patientid).Select(ai => new {

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
                    AdminInfo = _context.AdminInfo.Where(ai => ai.id == p.adminid).Select(ai => new {
                        ai.id,
                        name = EncryptManager.Decrypt(ai.name),
                        image = EncryptManager.Decrypt(ai.image),
                        depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault()

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

                        op.usertypeid,
                        OperationAdminInfo = _context.AdminInfo.Where(ai => ai.id == op.adminid).Select(ai => new {
                            ai.id,
                            name = EncryptManager.Decrypt(ai.name),
                            image = EncryptManager.Decrypt(ai.image),
                            depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault()

                        }).FirstOrDefault(),
                        OperationImage = op.OperationImage.Where(oi => oi.operationid == op.id).Select(im => new {
                            image = EncryptManager.Decrypt(im.image),
                        }).ToList()
                    }).ToList()
                })
                .ToListAsync();
            if (Schedule == null) return NotFound();
            return Ok(Schedule);
        }

        [HttpGet("GetProfiles")]
        public async Task<ActionResult<IEnumerable<Schedule>>> GetProfiles()
        {
 
            var Schedule = await _context.Schedule.Include(p => p.Operation).Select(p => new
                {
                    p.id,
                    patientInfo = _context.PaitentIfno.Where(ai => ai.id == p.patientid).Select(ai => new {
                        ai.id,
                        name = EncryptManager.Decrypt(ai.name),
                        phone = EncryptManager.Decrypt(ai.phone1),

                    }).FirstOrDefault(),
                    AdminInfo = _context.AdminInfo.Where(ai => ai.id == p.adminid).Select(ai => new {
                        ai.id,
                        name = EncryptManager.Decrypt(ai.name),
                        image = EncryptManager.Decrypt(ai.image),
                        depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault()

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

                        op.usertypeid,
                        OperationAdminInfo = _context.AdminInfo.Where(ai => ai.id == op.adminid).Select(ai => new {
                            ai.id,
                            name = EncryptManager.Decrypt(ai.name),
                            image = EncryptManager.Decrypt(ai.image),
                            depart = _context.Department.Where(de => de.id == ai.departid).Select(de => EncryptManager.Decrypt(de.dscrp)).FirstOrDefault()

                        }).FirstOrDefault(),
                        OperationImage = op.OperationImage.Where(oi => oi.operationid == op.id).Select(im => new {
                            image = EncryptManager.Decrypt(im.image),
                        }).ToList()
                    }).ToList()
                })
                .ToListAsync();
            if (Schedule == null) return NotFound();
            return Ok(Schedule);
        }

        [HttpGet("GetImg")]
        public ActionResult GetImage(string filename)
        {
            string path = Path.Combine(Directory.GetCurrentDirectory(), "Upload\\OperationImg");
            var filepath = Path.Combine(path, filename);

            if (System.IO.File.Exists(filepath))
            {
                byte[] b = System.IO.File.ReadAllBytes(filepath);
                return File(b, "image/png");
            }

            return NotFound();
        }

    }
}
