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

namespace Laborator1
{
    public partial class Form1 : Form
    {

        SqlConnection connection = new SqlConnection(@"Data Source = DESKTOP-VIE9KJ7\SQLEXPRESS; " +
            "                                         Initial Catalog = RetailWebsiteAdministration;" +
            "                                         Integrated Security = True");

        SqlDataAdapter dataAdapterParent = new SqlDataAdapter(); // pentru a lua date din DB si a duce in aplicatie

        DataSet dataSetParent = new DataSet(); // are tablele si relatii

        SqlDataAdapter dataAdapterChild = new SqlDataAdapter();

        DataSet dataSetChild = new DataSet();

        public Form1()
        {
            InitializeComponent();
            this.AddItemsInsideParentDataGrid();
        }

        private void AddItemsInsideParentDataGrid()
        {
            this.dataAdapterParent.SelectCommand = new SqlCommand("SELECT * FROM Site", connection);
            this.dataSetParent.Clear();
            this.dataAdapterParent.Fill(dataSetParent);
            this.dataGridViewParent.DataSource = dataSetParent.Tables[0];
            this.dataGridViewParent.Columns["IdS"].Width = 50;
            this.dataGridViewParent.Columns["Adresa"].Width = 134;
        }

        private void AddItemsInsideChildDataGrid(int id)
        {
            this.dataGridViewChild.DataSource = null; // dam clear

            this.dataAdapterChild.SelectCommand = new SqlCommand("SELECT * FROM Categorie WHERE IdS = @i", connection);
            this.dataAdapterChild.SelectCommand.Parameters.Add("@i", SqlDbType.Int).Value = id;
            this.dataSetChild.Clear();
            this.dataAdapterChild.Fill(dataSetChild);
            this.dataGridViewChild.DataSource = dataSetChild.Tables[0];
        }

        private void DataGridViewChild_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            Console.WriteLine("Triggered");

            Int32 index = e.RowIndex;

            Int32 id = (int)this.dataGridViewChild.Rows[index].Cells["CodC"].Value;
            String nume = (String)this.dataGridViewChild.Rows[index].Cells["Nume"].Value;
            String domeniu = (String)this.dataGridViewChild.Rows[index].Cells["Domeniu"].Value;
            //int idS = (int)this.dataGridViewChild.Rows[index].Cells["IdS"].Value;

            this.CodCategorieTextBox.Text = id.ToString();
            this.NumeTextBox.Text = nume;
            this.DomeniuTextBox.Text = domeniu;

            //this.dataGridViewChild.ClearSelection();
        }

        private void DataGridViewParent_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            this.NumeTextBox.Text = null;
            this.DomeniuTextBox.Text = null;
            this.CodCategorieTextBox.Text = null;

            Int32 index = e.RowIndex;

            Int32 id = (int)this.dataGridViewParent.Rows[index].Cells["IdS"].Value;

            Console.WriteLine(id);

            this.AddItemsInsideChildDataGrid(id);

            this.IdSiteTextBox.Text = id.ToString();

            this.dataGridViewChild.Columns["CodC"].Width = 50;
            this.dataGridViewChild.Columns["IdS"].Width = 51;

            //this.dataGridViewChild.ClearSelection();
        }

        private void AdaugaButton_Click(object sender, EventArgs e)
        {
            try
            {
                String nume = this.NumeTextBox.Text;
                this.NumeTextBox.Text = null;

                String domeniu = this.DomeniuTextBox.Text;
                this.DomeniuTextBox.Text = null;

                String codCategorie = this.CodCategorieTextBox.Text;
                this.CodCategorieTextBox.Text = null;
                Int32 cod = Int32.Parse(codCategorie);

                Int32 idSite = Int32.Parse(this.IdSiteTextBox.Text);

                this.dataAdapterChild.InsertCommand = new SqlCommand("INSERT INTO Categorie(CodC, Nume, Domeniu, IdS) VALUES (@cod, @nume, @domeniu, @ids);", connection);
                this.dataAdapterChild.InsertCommand.Parameters.Add("@cod", SqlDbType.Int).Value = cod;
                this.dataAdapterChild.InsertCommand.Parameters.Add("@nume", SqlDbType.VarChar).Value = nume;
                this.dataAdapterChild.InsertCommand.Parameters.Add("@domeniu", SqlDbType.VarChar).Value = domeniu;
                this.dataAdapterChild.InsertCommand.Parameters.Add("@ids", SqlDbType.Int).Value = idSite;

                this.connection.Open();

                this.dataAdapterChild.InsertCommand.ExecuteNonQuery();

                this.AddItemsInsideChildDataGrid(idSite);

                MessageBox.Show("Categoria a fost adaugata cu succes!\n");

                this.connection.Close();
            } 
            catch (Exception err)
            {
                MessageBox.Show(err.Message);
                this.connection.Close();
            }

        }

        private void StergeButton_Click(object sender, EventArgs e)
        {
            try
            {
                this.NumeTextBox.Text = null;
                this.DomeniuTextBox.Text = null;

                String codCategorie = this.CodCategorieTextBox.Text;
                this.CodCategorieTextBox.Text = null;
                Int32 cod = Int32.Parse(codCategorie);

                Int32 idSite = Int32.Parse(this.IdSiteTextBox.Text);

                this.dataAdapterChild.DeleteCommand = new SqlCommand("DELETE FROM Categorie WHERE CodC = @cod", connection);
                this.dataAdapterChild.DeleteCommand.Parameters.Add("@cod", SqlDbType.Int).Value = cod;

                this.connection.Open();

                this.dataAdapterChild.DeleteCommand.ExecuteNonQuery();

                this.AddItemsInsideChildDataGrid(idSite);

                MessageBox.Show("Categoria a fost stearsa cu succes!\n");

                this.connection.Close();
            }
            catch (Exception err)
            {
                MessageBox.Show(err.Message);
                this.connection.Close();
            }
        }

        private void UpdateButton_Click(object sender, EventArgs e)
        {
            try
            {
                String nume = this.NumeTextBox.Text;
                this.NumeTextBox.Text = null;

                String domeniu = this.DomeniuTextBox.Text;
                this.DomeniuTextBox.Text = null;

                String codCategorie = this.CodCategorieTextBox.Text;
                this.CodCategorieTextBox.Text = null;
                Int32 cod = Int32.Parse(codCategorie);

                Int32 idSite = Int32.Parse(this.IdSiteTextBox.Text);

                this.dataAdapterChild.UpdateCommand = new SqlCommand("UPDATE Categorie SET Nume = @nume, Domeniu = @domeniu WHERE CodC = @cod;", connection);

                this.dataAdapterChild.UpdateCommand.Parameters.Add("@nume", SqlDbType.VarChar).Value = nume;
                this.dataAdapterChild.UpdateCommand.Parameters.Add("@domeniu", SqlDbType.VarChar).Value = domeniu;
                this.dataAdapterChild.UpdateCommand.Parameters.Add("@cod", SqlDbType.Int).Value = cod;

                this.connection.Open();

                int result = this.dataAdapterChild.UpdateCommand.ExecuteNonQuery();

                this.AddItemsInsideChildDataGrid(idSite);

                if (result > 0)

                    MessageBox.Show("A fost actualizata categoria!\n");

                else

                    MessageBox.Show("Nu a fost actualizata categoria!\n");

                this.connection.Close();
            }
            catch (Exception err)
            {
                MessageBox.Show(err.Message);
                this.connection.Close();
            }
        }
    }
}
