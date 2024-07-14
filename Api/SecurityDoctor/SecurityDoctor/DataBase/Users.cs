using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SecurityDoctor.DataBase
{
    [Table("T_Users")]
    public class Users
    {
        public int id { get; set; }
        public string email { get; set; }

        public string password { get; set; }
        [ForeignKey("UserTypes")]
        public int usertype { get; set; }
        [JsonIgnore]
        [XmlIgnore]
        public UserTypes UserTypes { get;  private set; }

    }
}
