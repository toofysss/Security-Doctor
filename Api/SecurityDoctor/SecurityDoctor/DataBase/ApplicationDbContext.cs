using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.DataBase
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
        public DbSet<Users> Users { get; set; }
        public DbSet<UserTypes> UserTypes { get; set; }
        public DbSet<Notification> Notification { get; set; }
        public DbSet<Department> Department { get; set; }
        public DbSet<PaitentIfno> PaitentIfno { get; set; }
        public DbSet<AdminInfo> AdminInfo { get; set; }
        public DbSet<Schedule> Schedule { get; set; }
        public DbSet<Operation> Operation { get; set; }
        public DbSet<OperationImage> OperationImage { get; set; }

    }
}
