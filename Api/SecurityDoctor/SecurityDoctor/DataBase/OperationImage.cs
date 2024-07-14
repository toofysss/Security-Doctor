using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.DataBase
{
    [Table("T_Operatin_Image")]
    public class OperationImage
    {
        public int id { get; set; }
        public string image { get; set; }
        public int operationid { get; set; }

    }
}
