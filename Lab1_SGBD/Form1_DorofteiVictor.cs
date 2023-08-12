using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lab01
{
    public partial class Form1 : Form
    {

        int codP;

        SqlConnection cs = new SqlConnection("Data Source=DESKTOP-8RAPUPI\\SQLEXPRESS;Initial Catalog=CompanieAeriana;Integrated Security=True");
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();
        BindingSource bs = new BindingSource();

        public Form1()
        {
            InitializeComponent();

            codP = -1;

            da.SelectCommand = new SqlCommand("SELECT * FROM Producatori", cs);

            ds.Clear();
            da.Fill(ds);

            dataGridView1.DataSource = ds.Tables[0];
            bs.DataSource = ds.Tables[0];
            
            if (ds.Tables[0].Rows[0][0] != null)
                codP = (int)ds.Tables[0].Rows[0][0];
        }

        private void displayButton_Click(object sender, EventArgs e)
        {
            if (codP != -1)
            {
                Form f2 = new Form2(codP);
                f2.ShowDialog();
            }
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                var value = dataGridView1.Rows[e.RowIndex].Cells[0].Value;
                if (value != null)
                {
                    codP = (int)value;
                    //Form2 f2 = new Form2((int)value);
                    //f2.ShowDialog();
                }
            }
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            try
            {

                if (codP == -1)
                    throw new Exception("Nu s-a selectat un rand valid!\n");

                if (numeTextBox.Text == "")
                    throw new Exception("Nume invalid!\n");

                da.DeleteCommand = new SqlCommand("INSERT INTO Avioane VALUES(@n, @c, @cp)");
                da.DeleteCommand.Connection = cs;

                da.DeleteCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = numeTextBox.Text;
                da.DeleteCommand.Parameters.Add("@c", SqlDbType.Int).Value = int.Parse(capacitateTextBox.Text);
                da.DeleteCommand.Parameters.Add("@cp", SqlDbType.Int).Value = codP;

                cs.Open();
                int num = da.DeleteCommand.ExecuteNonQuery();
                cs.Close();

                if (num >= 1)
                    MessageBox.Show("Avionul a fost introdus cu succes!");

                da.SelectCommand = new SqlCommand("SELECT * FROM Producatori", cs);

                ds.Clear();
                da.Fill(ds);

                dataGridView1.DataSource = ds.Tables[0];
                bs.DataSource = ds.Tables[0];

                numeTextBox.Clear();
                capacitateTextBox.Clear();

            }

            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }
        }
    }
}
