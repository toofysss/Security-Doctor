using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SecurityDoctor.DataBase
{
    [Table("T_Notification")]
    public class Notification
    {
        public int id { get; set; }
        public string message { get; set; }
        public int userid { get; set; }
        public int status { get; set; }
        public int schedule { get; set; }
    }
}
