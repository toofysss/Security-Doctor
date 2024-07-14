using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SecurityDoctor.DataBase
{
    [Table("T_Department")]
    public class Department
    {
        public int id { get; set; }
        public string dscrp { get; set; }
        [JsonIgnore]
        [XmlIgnore]
        public List<AdminInfo> AdminInfo { get; private set; }

    }
}
