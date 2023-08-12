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
    public partial class Form2 : Form
    {
        int codP;
        int selRow;

        SqlConnection cs = new SqlConnection("Data Source=DESKTOP-8RAPUPI\\SQLEXPRESS;Initial Catalog=CompanieAeriana;Integrated Security=True");
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();
        BindingSource bs = new BindingSource();

        public Form2(int codP)
        {
            InitializeComponent();

            this.codP = codP;
            selRow = -1;

            mainLabel.Text = "Avioanele cu codul producatorului " + codP;

            da.SelectCommand = new SqlCommand("SELECT * FROM Avioane WHERE CodP = @c", cs);
            da.SelectCommand.Parameters.Add("@c", SqlDbType.Int).Value = this.codP;

            ds.Clear();
            da.Fill(ds);

            dataGridView1.DataSource = ds.Tables[0];
            bs.DataSource = ds.Tables[0];

        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                var id = dataGridView1.Rows[e.RowIndex].Cells[0].Value;
                if (id != null)
                {
                    selRow = e.RowIndex;

                    var nume = dataGridView1.Rows[e.RowIndex].Cells[1].Value;
                    var capacitate = dataGridView1.Rows[e.RowIndex].Cells[2].Value;
                    var codPSelectat = dataGridView1.Rows[e.RowIndex].Cells[3].Value;

                    numeTextBox.Text = nume.ToString();
                    capacitateTextBox.Text = capacitate.ToString();
                    codPTextBox.Text = codP.ToString();
                }
            }
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void codPLabel_Click(object sender, EventArgs e)
        {

        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            try
            {

                if (selRow == -1)
                    throw new Exception("Nu s-a selectat un rand valid!\n");

                da.DeleteCommand = new SqlCommand("UPDATE Avioane SET Nume = @n, Capacitate = @c, CodP = @cp WHERE CodA = @ca");
                da.DeleteCommand.Connection = cs;

                da.DeleteCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = numeTextBox.Text;
                da.DeleteCommand.Parameters.Add("@c", SqlDbType.Int).Value = int.Parse(capacitateTextBox.Text);
                da.DeleteCommand.Parameters.Add("@cp", SqlDbType.Int).Value = int.Parse(codPTextBox.Text);
                da.DeleteCommand.Parameters.Add("@ca", SqlDbType.Int).Value = ds.Tables[0].Rows[selRow][0];

                cs.Open();
                int num = da.DeleteCommand.ExecuteNonQuery();
                cs.Close();

                if (num >= 1)
                    MessageBox.Show("Datele avionului au fost actualizate cu succes!");

                da.SelectCommand = new SqlCommand("SELECT * FROM Avioane WHERE CodP = @c", cs);
                da.SelectCommand.Parameters.Add("@c", SqlDbType.Int).Value = this.codP;

                ds.Clear();
                da.Fill(ds);

                dataGridView1.DataSource = ds.Tables[0];
                bs.DataSource = ds.Tables[0];

            }

            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }

        }

        private void deleteButton_Click(object sender, EventArgs e)
        {
            try
            {

                if (selRow == -1)
                    throw new Exception("Nu s-a selectat un rand valid!\n");

                da.DeleteCommand = new SqlCommand("DELETE FROM Avioane WHERE CodA = @c");
                da.DeleteCommand.Connection = cs;
                da.DeleteCommand.Parameters.Add("@c", SqlDbType.Int).Value = ds.Tables[0].Rows[selRow][0];
                
                cs.Open();
                int num = da.DeleteCommand.ExecuteNonQuery();
                cs.Close();

                if (num >= 1)
                    MessageBox.Show("Avionul a fost sters cu succes din baza de date!");

                da.SelectCommand = new SqlCommand("SELECT * FROM Avioane WHERE CodP = @c", cs);
                da.SelectCommand.Parameters.Add("@c", SqlDbType.Int).Value = this.codP;

                ds.Clear();
                da.Fill(ds);

                dataGridView1.DataSource = ds.Tables[0];
                bs.DataSource = ds.Tables[0];

            }

            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }
        }

        private void backButton_Click(object sender, EventArgs e)
        {
            this.Hide();
        }
    }
}
