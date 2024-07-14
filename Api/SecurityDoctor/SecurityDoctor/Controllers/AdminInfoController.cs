using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
    public class AdminInfoController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public AdminInfoController(ApplicationDbContext db) => _context = db;
        [HttpGet("AdminInfo")]
        public ActionResult<IEnumerable<AdminInfo>> GetAdminInfo(int userid)
        {
            var Paitent = _context.AdminInfo.Where(e => e.userid == userid).Select(u => new {
                u.id,
                name = EncryptManager.Decrypt(u.name),
                PersonID = EncryptManager.Decrypt(u.PersonID),
                address = EncryptManager.Decrypt(u.address),
                worklocation = EncryptManager.Decrypt(u.worklocation),
                workopen = EncryptManager.Decrypt(u.workopen),
                workclose = EncryptManager.Decrypt(u.workclose),
                phone = EncryptManager.Decrypt(u.phone),
                workdays = EncryptManager.Decrypt(u.workdays),
                dscrp = EncryptManager.Decrypt(u.dscrp),
                u.departid,
                image = EncryptManager.Decrypt(u.image),
                u.userid,
             }).ToList();
            return Ok(Paitent);
        }

        [HttpGet("byType")]
        public ActionResult<IEnumerable<AdminInfo>> GetbyType(int usertype)
        {
            var adminlist = _context.Users.Where(e => e.usertype == usertype).ToList();
            var patientIds = adminlist.Select(admin => admin.id).ToList();

            // Retrieve patient information based on the filtered adminlist ids
            var patients = _context.AdminInfo
                .Where(e => patientIds.Contains(e.userid))
                .Select(u => new {
                    u.id,
                    name = EncryptManager.Decrypt(u.name),
                    PersonID = EncryptManager.Decrypt(u.PersonID),
                    address = EncryptManager.Decrypt(u.address),
                    worklocation = EncryptManager.Decrypt(u.worklocation),
                    workopen = EncryptManager.Decrypt(u.workopen),
                    workclose = EncryptManager.Decrypt(u.workclose),
                    phone = EncryptManager.Decrypt(u.phone),
                    workdays = EncryptManager.Decrypt(u.workdays),
                    dscrp = EncryptManager.Decrypt(u.dscrp),
                    u.departid,
                    image = EncryptManager.Decrypt(u.image),
                    u.userid,
                })
                .ToList();

            return Ok(patients);

        }

        [HttpDelete("Delete")]
        public ActionResult<IEnumerable<AdminInfo>> DeleteAdminInfo(int userid)
        {
            var data = _context.AdminInfo.FirstOrDefault(x => x.userid == userid);
            if (data == null) return NotFound();
            FilesManager.RemoveFile(data.image, "Upload\\AdminImg");
 
            _context.AdminInfo.Remove(data);
            _context.SaveChanges();
            return Ok("success");
        }
        [HttpPost("Insert")]
        public async Task<ActionResult<IEnumerable<AdminInfo>>> InsertAdminInfo(IFormFile adminImg, [FromForm] AdminInfo AdminInfo)
        {
           if (adminImg != null)
            {
                AdminInfo.image = await FilesManager.Insertfiles(adminImg, "Upload\\AdminImg");
                AdminInfo.image = EncryptManager.Encrypt(AdminInfo.image);
            }
            if (AdminInfo == null) return BadRequest();

            
            AdminInfo.id = 0;
            AdminInfo.name = EncryptManager.Encrypt(AdminInfo.name);
            AdminInfo.address = EncryptManager.Encrypt(AdminInfo.address);
            AdminInfo.worklocation = EncryptManager.Encrypt(AdminInfo.worklocation);
            AdminInfo.workopen = EncryptManager.Encrypt(AdminInfo.workopen);
            AdminInfo.workclose = EncryptManager.Encrypt(AdminInfo.workclose);
            AdminInfo.PersonID = EncryptManager.Encrypt(AdminInfo.PersonID);

            AdminInfo.phone = EncryptManager.Encrypt(AdminInfo.phone);
            AdminInfo.dscrp = EncryptManager.Encrypt(AdminInfo.dscrp);
            AdminInfo.workdays = EncryptManager.Encrypt(AdminInfo.workdays);

            _context.AdminInfo.Add(AdminInfo);
            _context.SaveChanges();
            return Ok();
        }
        [HttpGet("GetImg")]
        public ActionResult GetImage(string filename)
        {
            string path = Path.Combine(Directory.GetCurrentDirectory(), "Upload\\AdminImg");
            var filepath = Path.Combine(path, filename);

            if (System.IO.File.Exists(filepath))
            {
                byte[] b = System.IO.File.ReadAllBytes(filepath);
                return File(b, "image/png");
            }

            return NotFound();
        }

        [HttpPut("Update")]
        public async Task<ActionResult<IEnumerable<PaitentIfno>>> UpdatePaitentIfnoAsync(IFormFile adminImg, [FromForm] AdminInfo AdminInfo)
        {
            var AdminInfoID = _context.AdminInfo.FirstOrDefault(x => x.userid.ToString() == AdminInfo.userid.ToString());
            if (AdminInfoID == null)
            {
                if (adminImg != null)
                {
                    AdminInfo.image = await FilesManager.Insertfiles(adminImg, "Upload\\AdminImg");
                    AdminInfo.image = EncryptManager.Encrypt(AdminInfo.image);
                }
                AdminInfo.id = 0;
                AdminInfo.name = EncryptManager.Encrypt(AdminInfo.name);
                AdminInfo.address = EncryptManager.Encrypt(AdminInfo.address);
                AdminInfo.worklocation = EncryptManager.Encrypt(AdminInfo.worklocation);
                AdminInfo.workopen = EncryptManager.Encrypt(AdminInfo.workopen);
                AdminInfo.workclose = EncryptManager.Encrypt(AdminInfo.workclose);
                AdminInfo.PersonID = EncryptManager.Encrypt(AdminInfo.PersonID);

                AdminInfo.phone = EncryptManager.Encrypt(AdminInfo.phone);
                AdminInfo.dscrp = EncryptManager.Encrypt(AdminInfo.dscrp);
                AdminInfo.workdays = EncryptManager.Encrypt(AdminInfo.workdays);

                _context.AdminInfo.Add(AdminInfo);
                _context.SaveChanges();
                return Ok();
            }

            if(adminImg != null)
            {
                FilesManager.RemoveFile(AdminInfoID.image, "Upload\\AdminImg");
                var image = await FilesManager.Insertfiles(adminImg, "Upload\\AdminImg");
                AdminInfoID.image = EncryptManager.Encrypt(image);
             }
            if(AdminInfo.name !=null) AdminInfoID.name = EncryptManager.Encrypt(AdminInfo.name);
            if (AdminInfo.worklocation != null) AdminInfoID.worklocation = EncryptManager.Encrypt(AdminInfo.worklocation);
            if (AdminInfo.workopen != null) AdminInfoID.workopen = EncryptManager.Encrypt(AdminInfo.workopen);
            if (AdminInfo.address != null) AdminInfoID.address = EncryptManager.Encrypt(AdminInfo.address);
            if (AdminInfo.workclose != null) AdminInfoID.workclose = EncryptManager.Encrypt(AdminInfo.workclose);
            if (AdminInfo.phone != null) AdminInfoID.phone = EncryptManager.Encrypt(AdminInfo.phone);
            if (AdminInfo.dscrp != null) AdminInfoID.dscrp = EncryptManager.Encrypt(AdminInfo.dscrp);
            if (AdminInfo.workdays != null) AdminInfoID.workdays = EncryptManager.Encrypt(AdminInfo.workdays);
            if (AdminInfo.PersonID != null) AdminInfoID.PersonID = EncryptManager.Encrypt(AdminInfo.PersonID);
            if (AdminInfo.departid > 0) AdminInfoID.departid = AdminInfo.departid;

            _context.AdminInfo.Update(AdminInfoID);
            _context.SaveChanges();
            return Ok();
        }
    }
}
