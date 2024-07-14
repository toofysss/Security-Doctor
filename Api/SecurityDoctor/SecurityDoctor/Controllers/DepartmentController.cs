using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SecurityDoctor.DataBase;
using SecurityDoctor.Modles;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DepartmentController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public DepartmentController(ApplicationDbContext db) => _context = db;
        [HttpGet("AllDepart")]
        public ActionResult<IEnumerable<Department>> GetAllDepart()
        {
            var depart = _context.Department.Select(u => new {
                u.id,
                dscrp = EncryptManager.Decrypt(u.dscrp),
            
            }).ToList();
            return Ok(depart);
         }

        [HttpGet("All")]
        public ActionResult<IEnumerable<Department>> GetAll( int usertype)
        {
            var depart = _context.Department.Include(p => p.AdminInfo).Select(u => new
            {
                u.id,
                dscrp = EncryptManager.Decrypt(u.dscrp),
                admininfo = _context.AdminInfo.Where(ad => ad.departid == u.id && ad.Users.usertype == usertype).Select(ad => new
                {
                    ad.id,
                    name = EncryptManager.Decrypt(ad.name),
                    address = EncryptManager.Decrypt(ad.address),
                    worklocation = EncryptManager.Decrypt(ad.worklocation),
                    workopen = EncryptManager.Decrypt(ad.workopen),
                    workclose = EncryptManager.Decrypt(ad.workclose),
                    phone = EncryptManager.Decrypt(ad.phone),
                    workdays = EncryptManager.Decrypt(ad.workdays),
                    PersonID = EncryptManager.Decrypt(ad.PersonID),
                    dscrp = EncryptManager.Decrypt(ad.dscrp),
                    depart = EncryptManager.Decrypt(u.dscrp),
                    image = EncryptManager.Decrypt(ad.image),
                    //ad.userid,
                }).ToList()
            }).ToList();
            return Ok(depart);
        }

        [HttpPost("InsertDepart")]
        public ActionResult<IEnumerable<Department>> InsertDepart([FromBody] Department department)
        {
            department.dscrp = EncryptManager.Encrypt(department.dscrp);
            _context.Department.Add(department);
            _context.SaveChanges();
            return Ok();
        }

        [HttpPut("UpdateDepart")]
        public ActionResult<IEnumerable<Department>> UpdateDepart([FromBody] Department department)
        {
            var departmentID = _context.Department.FirstOrDefault(x => x.id == department.id);
            if (departmentID == null) return NotFound();
            if (department.dscrp != null) departmentID.dscrp =EncryptManager.Encrypt(department.dscrp);
            _context.Department.Update(departmentID);
            _context.SaveChanges();
            return Ok();
        }

        [HttpDelete("DeleteDepart")]
        public ActionResult<IEnumerable<Department>> DeleteDepart(int id)
        {
            var departmentID = _context.Department.FirstOrDefault(x => x.id == id);
            if (departmentID == null) return NotFound();
            _context.Department.Remove(departmentID);
            _context.SaveChanges();
            return Ok();
        }
    }
}
