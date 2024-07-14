using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MimeKit;
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
    public class UsersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public UsersController(ApplicationDbContext db) => _context = db;

        [HttpGet("AllUsers")]
        public ActionResult<IEnumerable<Users>> GetAllUser()
        {
            var user = _context.Users.Select(u => new {
                u.id,
                email = EncryptManager.Decrypt(u.email),
                u.password,
                u.usertype,
                u.UserTypes.name
            }).ToList();
            return Ok(user);
        }
        [HttpGet("CheckLogin")]
        public IActionResult CheckLogin(string email, string pass)
        {

            if (email == null) return BadRequest();
            email = EncryptManager.Encrypt(email);
            pass = EncryptManager.Encrypt(pass);

            var user = _context.Users.Where(u => u.email == email && u.password == pass).Select(u => new {
                u.id,
                email = EncryptManager.Decrypt(u.email),
                password = EncryptManager.Decrypt(u.password),
                u.usertype,
                u.UserTypes.name
            }).FirstOrDefault();
            if (user == null) return NotFound();
            return Ok(user);
        }
  
        [HttpGet("SendMail")]
        public IActionResult AddUser(string Email)
        {
            var authCode = SendEmail.SendEmailMessage(Email);
            return Ok(authCode);
        }
        [HttpPost("Insert")]
        public IActionResult AddUser([FromBody] Users Users)
        {

            if (Users == null) return BadRequest();
            Users.password = EncryptManager.Encrypt(Users.password);
            Users.email = EncryptManager.Encrypt(Users.email);

            var existingUser = _context.Users.FirstOrDefault(u => u.email == Users.email);
            if (existingUser != null) return Conflict("Email already exists");
            _context.Users.Add(Users);
            _context.SaveChanges();
            var newUser = _context.Users.Where(u => u.email == Users.email).Select(u => new
            {
                u.id,
                email = EncryptManager.Decrypt(u.email),
                password = EncryptManager.Decrypt(u.password),
                u.usertype,
                u.UserTypes.name
            }).FirstOrDefault();

            if(Users.usertype == 4)
            {
                var paitentIfno = new PaitentIfno
                {
                    userid = newUser.id,
                    name = EncryptManager.Encrypt(""),
                    address = EncryptManager.Encrypt(""),
                    phone1 = EncryptManager.Encrypt(""),
                    phone2 = EncryptManager.Encrypt(""),
                    notes = EncryptManager.Encrypt(""),


                };
                _context.PaitentIfno.Add(paitentIfno);
                _context.SaveChanges();
            }
            else if (Users.usertype != 4 && Users.usertype != 5)
            {
                var adminInfo = new AdminInfo
                {
                    userid = newUser.id,
                    address = EncryptManager.Encrypt(""),
                    name = EncryptManager.Encrypt(""),
                    worklocation = EncryptManager.Encrypt(""),
                    workopen = EncryptManager.Encrypt(""),
                    workclose = EncryptManager.Encrypt(""),
                    workdays = EncryptManager.Encrypt(""),
                    phone = EncryptManager.Encrypt(""),
                    dscrp = EncryptManager.Encrypt(""),
                    PersonID = EncryptManager.Encrypt(""),
                    image = EncryptManager.Encrypt(""),

                };
                _context.AdminInfo.Add(adminInfo);
                _context.SaveChanges();
            }
         
            return Ok(newUser);
        }
        [HttpPut("UpdatePasswordUser")]
        public ActionResult<IEnumerable<Users>> UpdatePasswordUser(int id,string password)
        {
            var UsersID = _context.Users.FirstOrDefault(x => x.id == id);
            if (UsersID == null) return NotFound();
            UsersID.password = EncryptManager.Encrypt(password);
            _context.Users.Update(UsersID);
            _context.SaveChanges();
            return Ok();
        }
        [HttpDelete("Delete")]
        public ActionResult<IEnumerable<Users>> DeleteUser(int id)
        {
            var UsersID = _context.Users.FirstOrDefault(x => x.id == id);
            if (UsersID == null) return NotFound();
            _context.Users.Remove(UsersID);
            _context.SaveChanges();
            return Ok();
        }

        [HttpGet("ForgetPasswrod")]
        public IActionResult ForgetPasswrod(string email, int type)
        {
            if(type == 0)
            {
               var Encryptemail = EncryptManager.Encrypt(email);
                var user = _context.Users.FirstOrDefault(u => u.email == Encryptemail);
                if (user == null) return NotFound();
                var authCode = SendEmail.SendEmailMessage(email);

                var data = new
                {
                    id = user.id,
                    usertype = user.usertype,
                    email = EncryptManager.Decrypt(user.email),
                    authCode = authCode
                };
                return Ok(data);
            }
            else
            {
                var authCode = "";
                var data = new object();
                var paitentinfo = _context.PaitentIfno.FirstOrDefault(e => e.phone1 == EncryptManager.Encrypt(email));
                if (paitentinfo == null)
                {
                    var admininfo = _context.AdminInfo.FirstOrDefault(e => e.phone == EncryptManager.Encrypt(email));
                    if (admininfo == null) return NotFound();
                    var adminID = _context.Users.FirstOrDefault(e => e.id == admininfo.userid);
                    authCode = SendMobile.SendMoibileSms(email);
                      data = new
                    {
                        id = adminID.id,
                        usertype = adminID.usertype,
                        email = EncryptManager.Decrypt(adminID.email),
                        authCode = authCode
                    };
                    return Ok(data);
                }
                var paitentID = _context.Users.FirstOrDefault(e => e.id == paitentinfo.userid);
                authCode = SendMobile.SendMoibileSms(email);
                data = new
                {
                    id = paitentID.id,
                    usertype = paitentID.usertype,
                    email = EncryptManager.Decrypt(paitentID.email),
                    authCode = authCode
                };
                return Ok(data);
                return Ok(data);
            }

        }


    }
}
