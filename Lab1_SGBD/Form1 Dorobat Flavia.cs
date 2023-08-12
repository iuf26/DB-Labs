using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace DorobatFlaviaL1
{
    public partial class Form1 : Form
    {

        SqlConnection connection = new SqlConnection("Data Source=DESKTOP-1QOE7F0\\SQLEXPRESS;Initial Catalog=InstallationCompany;Integrated Security=True");
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();
        DataSet dt = new DataSet();
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            da.SelectCommand = new SqlCommand("SELECT * FROM Plumbers ", connection);
            ds.Clear();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                int id_instalator = dataGridView1.CurrentCell.RowIndex;
                object id_i = dataGridView1[0, id_instalator].Value;

                da.InsertCommand = new SqlCommand("INSERT INTO Tools (Name, Quantity, Price, Pid, Did) VALUES(@n,@q,@p,@p1,@d1)", connection);
                da.InsertCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = textBox1.Text;
                da.InsertCommand.Parameters.Add("@q", SqlDbType.Int).Value = numericQuantity.Value; 


                da.InsertCommand.Parameters.Add("@p", SqlDbType.Int).Value = Int32.Parse(textBox3.Text);
                da.InsertCommand.Parameters.Add("@p1", SqlDbType.Int).Value = Int32.Parse(id_i.ToString());
                da.InsertCommand.Parameters.Add("@d1", SqlDbType.Int).Value = Int32.Parse(textBox4.Text);


                connection.Open();
                da.InsertCommand.ExecuteNonQuery();
                MessageBox.Show("Tool-ul a fost introdus cu succes!");
                connection.Close();
                dt.Clear();
                da.Fill(dt);
                dataGridView2.DataSource = dt.Tables[0];

                
                textBox1.Clear();
                numericQuantity.Value = 0;
                textBox3.Clear();
                textBox4.Clear();
              

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                connection.Close();
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
          

             try
            {
                int id_tool = dataGridView2.CurrentCell.RowIndex;
                object id_t = dataGridView2[0, id_tool].Value;
                da.DeleteCommand = new SqlCommand("DELETE FROM Tools WHERE Tid=@idTool", connection);
                da.DeleteCommand.Parameters.Add("@idTool", SqlDbType.Int).Value = Int32.Parse(id_t.ToString());
                connection.Open();
                da.DeleteCommand.ExecuteNonQuery();
                MessageBox.Show("Tool-ul a fost eliminat cu succes!");
                connection.Close();
                dt.Clear();
                da.Fill(dt);
                dataGridView2.DataSource = dt.Tables[0];

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                connection.Close();
            }

        }

        private void button5_Click(object sender, EventArgs e)
        {
          

              try
            {
                int id_instalator = dataGridView1.CurrentCell.RowIndex;
                object id_i = dataGridView1[0, id_instalator].Value;
                da.SelectCommand = new SqlCommand("SELECT * FROM Tools WHERE Pid=@idInstalator", connection);
                da.SelectCommand.Parameters.Add("@idInstalator", SqlDbType.Int).Value = Int32.Parse(id_i.ToString());
                dt.Clear();
                da.Fill(dt);
                dataGridView2.DataSource = dt.Tables[0];

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                connection.Close();
            }

        }

        private void button4_Click(object sender, EventArgs e)
        {
          

             try
            {
                int id_tool = dataGridView2.CurrentCell.RowIndex;
                object id_t = dataGridView2[0, id_tool].Value;

                if(textBox1.Text.Length!=0)
                    da.UpdateCommand = new SqlCommand("UPDATE Tools SET Name=@n WHERE Tid=@idTool", connection);

                if(numericQuantity.Value!=0 )
                    da.UpdateCommand = new SqlCommand("UPDATE Tools SET Quantity=@q WHERE Tid=@idTool", connection);

                if (textBox3.Text.Length != 0)
                    da.UpdateCommand = new SqlCommand("UPDATE Tools SET Price=@p WHERE Tid=@idTool", connection);

                if (textBox4.Text.Length != 0)
                    da.UpdateCommand = new SqlCommand("UPDATE Tools SET Did=@d WHERE Tid=@idTool", connection);


                //Daca am actualiza toate datele in acelasi timp: 
                // da.UpdateCommand = new SqlCommand("UPDATE Tools SET Name=@n, Quantity=@q, Price=@p, Did=@d WHERE Tid=@idTool", connection);


                if (textBox1.Text.Length != 0)
                {
                    da.UpdateCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = textBox1.Text;
                    textBox1.Clear();
                }


                if (numericQuantity.Value != 0 )
                {
                    da.UpdateCommand.Parameters.Add("@q", SqlDbType.VarChar).Value = numericQuantity.Value;
                    numericQuantity.Value = 0;
                }

                if (textBox3.Text.Length != 0)
                {
                    da.UpdateCommand.Parameters.Add("@p", SqlDbType.Int).Value = Int32.Parse(textBox3.Text);
                    textBox3.Clear();
                }

                if (textBox4.Text.Length != 0)
                {
                    da.UpdateCommand.Parameters.Add("@d", SqlDbType.Int).Value = Int32.Parse(textBox4.Text);
                    textBox4.Clear();
                }



                da.UpdateCommand.Parameters.Add("@idTool", SqlDbType.Int).Value = Int32.Parse(id_t.ToString());

                connection.Open();
                da.UpdateCommand.ExecuteNonQuery();

                MessageBox.Show("Informatiile despre tool-ul selectat au fost actualizate cu succes!");
                connection.Close();
                dt.Clear();
                da.Fill(dt);
                dataGridView2.DataSource = dt.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                connection.Close();
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {
        }

        private void label5_Click_1(object sender, EventArgs e)
        {

        }
    }

}

