using Microsoft.AspNetCore.Mvc;
using SecurityDoctor.DataBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserTypesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public UserTypesController(ApplicationDbContext db) => _context = db;
        [HttpGet("AllUserType")]
        public ActionResult<IEnumerable<UserTypes>> GetUser()
        {
            return Ok(_context.UserTypes);
        }
        [HttpPost("Insert")]
        public ActionResult<IEnumerable<UserTypes>> InsertUser([FromBody] UserTypes users)
        {
            _context.UserTypes.Add(users);
            _context.SaveChanges();
            return Ok();
        }
  
        [HttpPut("Update")]
        public ActionResult<IEnumerable<UserTypes>> UpdateUser([FromBody] UserTypes users)
        {
            var UsersID = _context.UserTypes.FirstOrDefault(x => x.id == users.id);
            if (UsersID == null) return NotFound();
            if (UsersID.name != null) UsersID.name = users.name;
            _context.UserTypes.Update(UsersID);
            _context.SaveChanges();
            return Ok();
        }
        [HttpDelete("Delete")]
        public ActionResult<IEnumerable<UserTypes>> DeleteUser(int id)
        {
            var UsersID = _context.UserTypes.FirstOrDefault(x => x.id == id);
            if (UsersID == null) return NotFound();
            _context.UserTypes.Remove(UsersID);
            _context.SaveChanges();
            return Ok();
        }
    }
}
