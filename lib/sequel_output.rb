require 'db_output'

class SequelOutput < BaseOutput
  attr_accessor :db_handle
  attr_accessor :unique_id
  attr_accessor :jobs_table

  def self.prepare_database(db_handle, jobs_table = :progress_bars)
    ensure_progress_table_exists(db_handle, jobs_table)
  end
  
  def initialize(unique_id, db_handle, jobs_table = :progress_bars)
    @jobs_table = jobs_table
    # puts "SequelOutput: initialize"
    @unique_id = unique_id
    @dbh = db_handle
    create_progress_bar
  end
  
  def post(progress_text, percentage, finished)
    # puts "SequelOutput: post('...', #{percentage}, #{finished})"
    end_time = finished ? Time.now : nil
    @dbh[@jobs_table].filter(:id => @unique_id).
      update(:progress_text => progress_text, 
        :progress_percent => percentage,
        :last_updated => Time.now,
        :job_finish => end_time)
  end

  def progress_text
    # puts "SequelOutput: progress_text"
    @dbh[@jobs_table].filter(:id => @unique_id).
      select(:progress_text).first[:progress_text]
  end
  
  def progress_percent
    # puts "SequelOutput: progress_percent"
    @dbh[@jobs_table].filter(:id => @unique_id).
      select(:progress_percent).first[:progress_percent]
  end
  
  private
  
  def create_progress_bar
    # puts "SequelOutput: create_progress_bar"
    if @dbh[@jobs_table].filter(:id => @unique_id).first
      @dbh[@jobs_table].filter(:id => @unique_id).
        update(:progress_text => '', 
          :progress_percent => 0,
          :job_start => Time.now,
          :last_updated => Time.now,
          :job_finish => nil)
    else
      @dbh[@jobs_table].
        insert(:id => @unique_id, 
          :progress_text => '', 
          :job_start => Time.now, 
          :last_updated => Time.now)
    end
  end
  
  def self.ensure_progress_table_exists(db_handle, jobs_table)
    # puts "SequelOutput: ensure_progress_table_exists"
    return true if db_handle.table_exists?(jobs_table)
    db_handle.create_table(jobs_table) do
      primary_key :id
      String :progress_text
      Integer :progress_percent, :size => 3
      DateTime :job_start
      DateTime :last_updated
      DateTime :job_finish
    end
    puts "SequelOutput: ensure_progress_table_exists created the '#{jobs_table}' table."
  end
end
