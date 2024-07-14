using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.DataBase
{
    [Table("T_UserTypes")]
    public class UserTypes
    {
        public int id { get; set; }
        public string name { get; set; }
    }
}
