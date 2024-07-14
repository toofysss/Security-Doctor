using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SecurityDoctor.DataBase
{
    [Table("T_Schedule")]
    public class Schedule
    {
        public int id { get; set; }
        public int patientid { get; set; }
        public int usertypeid { get; set; }
        public int adminid { get; set; }
        public int status { get; set; }
        public string opendate { get; set; }
        public string closedate { get; set; }
        [JsonIgnore]
        [XmlIgnore]
        public List<Operation> Operation { get; private set; }
    }
}
