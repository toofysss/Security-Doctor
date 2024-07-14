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
    public class PaitentIfnoController :ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public PaitentIfnoController(ApplicationDbContext db) => _context = db;
        [HttpGet("PaitentInfo")]
        public ActionResult<IEnumerable<PaitentIfno>> GetPaitentIfno(int userid)
        {
            var Paitent = _context.PaitentIfno.Where(e => e.userid ==userid).Select(u => new {
                u.id,
                name = EncryptManager.Decrypt(u.name),
                u.age,
                address = EncryptManager.Decrypt(u.address),
                phone1 = EncryptManager.Decrypt(u.phone1),
                phone2 = EncryptManager.Decrypt(u.phone2),
                notes = EncryptManager.Decrypt(u.notes),
                u.blood,
                u.userid,
                u.gender
                }).ToList();
            return Ok(Paitent);
        }
        [HttpDelete("Delete")]
        public ActionResult<IEnumerable<PaitentIfno>> DeletePaitent(int userid)
        {
            var PaitentIfnoID = _context.PaitentIfno.FirstOrDefault(x => x.userid == userid);
            if (PaitentIfnoID == null) return NotFound();
            _context.PaitentIfno.Remove(PaitentIfnoID);
            _context.SaveChanges();
            return Ok();
        }
        [HttpPost("Insert")]
        public IActionResult AddPaitentIfno([FromBody] PaitentIfno PaitentIfno)
        {
            if (PaitentIfno == null) return BadRequest();
            PaitentIfno.name = EncryptManager.Encrypt(PaitentIfno.name);
            PaitentIfno.address = EncryptManager.Encrypt(PaitentIfno.address);
            PaitentIfno.phone1 = EncryptManager.Encrypt(PaitentIfno.phone1);
            PaitentIfno.phone2 = EncryptManager.Encrypt(PaitentIfno.phone2);
            PaitentIfno.notes = EncryptManager.Encrypt(PaitentIfno.notes);
 
            _context.PaitentIfno.Add(PaitentIfno);
            _context.SaveChanges();
            return Ok();
        }
        [HttpPut("Update")]
        public ActionResult<IEnumerable<PaitentIfno>> UpdatePaitentIfno([FromBody] PaitentIfno PaitentIfno)
        {
            var PaitentIfnoID = _context.PaitentIfno.FirstOrDefault(x => x.userid == PaitentIfno.userid);
            if (PaitentIfnoID == null) return NotFound();
            if (PaitentIfnoID.name != null) PaitentIfnoID.name = EncryptManager.Encrypt(PaitentIfno.name);
            if (PaitentIfnoID.age.ToString() != null) PaitentIfnoID.age = PaitentIfno.age;
            if (PaitentIfnoID.address != null) PaitentIfnoID.address = EncryptManager.Encrypt(PaitentIfno.address);
            if (PaitentIfnoID.phone1 != null) PaitentIfnoID.phone1 = EncryptManager.Encrypt(PaitentIfno.phone1);
            if (PaitentIfnoID.phone2 != null) PaitentIfnoID.phone2 = EncryptManager.Encrypt(PaitentIfno.phone2);
            if (PaitentIfnoID.notes != null) PaitentIfnoID.notes = EncryptManager.Encrypt(PaitentIfno.notes);
            if (PaitentIfnoID.blood != null) PaitentIfnoID.blood =  PaitentIfno.blood;
            if (PaitentIfnoID.gender.ToString() != null) PaitentIfnoID.gender = PaitentIfno.gender;
            if (PaitentIfnoID.userid.ToString() != null) PaitentIfnoID.userid = PaitentIfno.userid;

            _context.PaitentIfno.Update(PaitentIfnoID);
            _context.SaveChanges();
            return Ok();
        }
    }
}
