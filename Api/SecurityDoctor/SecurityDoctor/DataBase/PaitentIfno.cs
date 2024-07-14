using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.DataBase
{
    [Table("T_PatientInfo")]
    public class PaitentIfno
    {
        public int id { get; set; }
        public string name { get; set; }
        public int age { get; set; }
        public string address { get; set; }
        public string phone1 { get; set; }
        public string phone2 { get; set; }
        public int userid { get; set; }
        public int gender { get; set; }
        public string blood { get; set; }
        public string notes { get; set; }
 
    }
}
