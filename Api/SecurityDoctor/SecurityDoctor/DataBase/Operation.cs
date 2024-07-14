using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SecurityDoctor.DataBase
{
    [Table("T_Operation")]
    public class Operation
    {
         public int id { get; set; }
         public int scheduleid{get;set;}
        public int adminid { get; set; }
        public int usertypeid { get; set; }

        public int status { get; set; }
        public string notes { get; set; }
        public string answers { get; set; }
        [JsonIgnore]
        [XmlIgnore]
        public List<OperationImage> OperationImage { get; private   set; }
        [JsonIgnore]
        [XmlIgnore]
        public Schedule Schedule { get; private set; }
    }
}
