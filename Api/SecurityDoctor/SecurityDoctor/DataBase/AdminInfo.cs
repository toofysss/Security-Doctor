using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SecurityDoctor.DataBase
{
    [Table("T_AdminInfo")]
    public class AdminInfo
    {
        public int id { get; set; }
        public string name { get; set; }
        public string address { get; set; }
        public int userid { get; set; }
        public int departid { get; set; }
        public string worklocation { get; set; }
        public string workopen { get; set; }
        public string workclose { get; set; }
        public string workdays { get; set; }
        public string phone { get; set; }
        public string dscrp { get; set; }
        public string image { get; set; }
        public string PersonID { get; set; }
        [JsonIgnore]
        [XmlIgnore]
        [ForeignKey("userid")]
        public Users Users { get; private set; }
        [JsonIgnore]
        [XmlIgnore]
        [ForeignKey("departid")]
        public Department Department { get; private set; }
    }
}
