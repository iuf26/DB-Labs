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


namespace L1
{
    public partial class Form1 : Form
    {
        SqlConnection sqlConnection = new SqlConnection("Data Source = DESKTOP-RP3BIR1\\SQLEXPRESS; Initial " +
        "Catalog = RoundTheGlobe; Integrated Security = True");
        SqlDataAdapter dataAdapter = new SqlDataAdapter();
        DataSet artistDataSet = new DataSet();
        DataSet songDataSet = new DataSet();
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            refreshArtists();
            refreshSongs();
        }
        private void refreshArtists()
        {
            dataAdapter.SelectCommand = new SqlCommand("Select * from Artist", sqlConnection);
            artistDataSet.Clear();
            dataAdapter.Fill(artistDataSet);
            artistDataGridView.DataSource = artistDataSet.Tables[0];
            refreshSongs();
        }
        private void refreshSongs()
        {
            if (artistDataGridView.SelectedRows.Count > 0)
            {
                dataAdapter.SelectCommand = new SqlCommand("Select * from Song where ArtistId=@a", sqlConnection);
                dataAdapter.SelectCommand.Parameters.Add("@a", SqlDbType.Int).Value = artistDataSet.Tables[0].Rows[artistDataGridView.SelectedRows[0].Index][0];
                songDataSet.Clear();
                dataAdapter.Fill(songDataSet);
                songDataGridView.DataSource = songDataSet.Tables[0];
            }
        }
        private void refreshButton_Click(object sender, EventArgs e)
        {
            refreshArtists();
        }

        private void artistDataGridView_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            refreshSongs();
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (songDataGridView.SelectedRows.Count > 0)
                {
                    dataAdapter.UpdateCommand = new SqlCommand("Update Song set Name=@n,Minutes=@m,Genre=@g where SongId=@id", sqlConnection);
                    dataAdapter.UpdateCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = nameTextBox.Text;
                    dataAdapter.UpdateCommand.Parameters.Add("@m", SqlDbType.Int).Value = Int32.Parse(minutesTextBox.Text);
                    dataAdapter.UpdateCommand.Parameters.Add("@g", SqlDbType.VarChar).Value = genreTextBox.Text;
                    dataAdapter.UpdateCommand.Parameters.Add("@id", SqlDbType.Int).Value = songDataSet.Tables[0].Rows[songDataGridView.SelectedRows[0].Index][0];
                    sqlConnection.Open();
                    int noUpdated = 0;
                    noUpdated = dataAdapter.UpdateCommand.ExecuteNonQuery();
                    sqlConnection.Close();
                    if (noUpdated > 0)
                    {
                        MessageBox.Show("Update Succesful!");
                    }
                    else
                    {
                        MessageBox.Show("Update Failed!");
                    }
                }
            }catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                sqlConnection.Close();
            }
            refreshSongs();
        }

        private void deleteButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (songDataGridView.SelectedRows.Count > 0)
                {
                    dataAdapter.DeleteCommand = new SqlCommand("Delete from Song where SongId=@id", sqlConnection);
                    dataAdapter.DeleteCommand.Parameters.Add("@id", SqlDbType.Int).Value = songDataSet.Tables[0].Rows[songDataGridView.SelectedRows[0].Index][0];
                    sqlConnection.Open();
                    int noDeleted = 0;
                    noDeleted = dataAdapter.DeleteCommand.ExecuteNonQuery();
                    sqlConnection.Close();
                    if (noDeleted> 0)
                    {
                        MessageBox.Show("Deletion Succesful!");
                    }
                    else
                    {
                        MessageBox.Show("Deletion Failed!");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                sqlConnection.Close();
            }
            refreshSongs();
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (artistDataGridView.SelectedRows.Count > 0)
                {
                    dataAdapter.InsertCommand = new SqlCommand("Insert into Song(Name,ArtistId,Minutes,Genre) values(@n,@aid,@m,@g)", sqlConnection);
                    dataAdapter.InsertCommand.Parameters.Add("@n", SqlDbType.VarChar).Value = nameTextBox.Text;
                    dataAdapter.InsertCommand.Parameters.Add("@aid", SqlDbType.Int).Value = artistDataSet.Tables[0].Rows[artistDataGridView.SelectedRows[0].Index][0];
                    dataAdapter.InsertCommand.Parameters.Add("@m", SqlDbType.Int).Value = Int32.Parse(minutesTextBox.Text);
                    dataAdapter.InsertCommand.Parameters.Add("@g", SqlDbType.VarChar).Value = genreTextBox.Text;
                    sqlConnection.Open();
                    int noUpdated = 0;
                    noUpdated = dataAdapter.InsertCommand.ExecuteNonQuery();
                    sqlConnection.Close();
                    if (noUpdated > 0)
                    {
                        MessageBox.Show("Insert Succesful!");
                    }
                    else
                    {
                        MessageBox.Show("Insert Failed!");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                sqlConnection.Close();
            }
            refreshSongs();
        }
    }
}
