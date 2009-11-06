require 'lib/db_output'

class SequelOutput < BaseOutput
  attr_accessor :db_handle
  attr_accessor :unique_id

  def initialize(unique_id, db_handle)
    @unique_id = unique_id
    @db_handle = db_handle
    create_progress_bar
  end
  
  def post(progress_text, percentage, finished)
    end_time = finished ? Time.now : nil
    @db_handle[:progress_bars].filter(:id => @unique_id).
      update(:progress_text => progress_text, 
        :progress_percent => percentage,
        :last_updated => Time.now,
        :job_finish => end_time)
  end

  def progress_text
    @db_handle[:progress_bars].filter(:id => @unique_id).select(:progress_text).first[:progress_text]
  end
  
  def progress_percent
    @db_handle[:progress_bars].filter(:id => @unique_id).select(:progress_percent).first[:progress_percent]
  end
  
  private
  
  def create_progress_bar
    ensure_progress_table_exists
    @db_handle[:progress_bars].insert(:id => @unique_id, 
      :progress_text => '', :job_start => Time.now, :last_updated => Time.now)
  end
  
  def ensure_progress_table_exists
    return true if @db_handle.tables.include?(:progress_bars)
    @db_handle.create_table(:progress_bars) do
      primary_key :id
      String :progress_text
      Decimal :progress_percent
      DateTime :job_start
      DateTime :last_updated
      DateTime :job_finish
    end
  end
end