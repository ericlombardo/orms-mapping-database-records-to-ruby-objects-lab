class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)   # takes in row of raw data
    self.new.tap {|student|   # creates new instance
      student.id = row[0]     # assigns data to matching variables
      student.name = row[1]
      student.grade = row[2]}
  end

  def self.all  # gets all students from database
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map {|student|
      self.new_from_db(student)}  # creates new instances for them
  end
  
  def self.find_by_name(name)   # find students that match, create instance for them
    sql = <<-SQL
    SELECT * FROM students      -- find name match query
    WHERE name == name
    SQL

    DB[:conn].execute(sql).map {|student| # get them and create new instance
      self.new_from_db(student)
    }.first # this returns the first element in array
  end

  def self.all_students_in_grade_9  # gets 9th graders, creates instances of them
    sql = <<-SQL
      SELECT * FROM students  -- gets 9th graders query
      WHERE grade == "9"
    SQL
    DB[:conn].execute(sql).map {|student| # gets data and creates instances
      self.new_from_db(student)
    }
  end

  def self.students_below_12th_grade  
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < "12"        -- query to get grades below 12th
    SQL
    DB[:conn].execute(sql).map {|student|   # gets data, creates instances for each
      self.new_from_db(student)
    }
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students    -- query for find
      WHERE grade == "10"       -- 10th graders
      LIMIT ?                   -- only show x number of them
    SQL

    DB[:conn].execute(sql, x).map {|student|  # executes query and creates instances
      self.new_from_db(student)
    }
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students  -- query for finding 10 graders
      WHERE grade == "10"
      LIMIT 1     -- only shows 1
    SQL
    DB[:conn].execute(sql).map {|student| # executes query and creates instance
      self.new_from_db(student)
    }.first
  end

  def self.all_students_in_grade_X(grade) 
    sql = <<-SQL
      SELECT * FROM students  -- query for finding students
      WHERE grade == ?    -- in selected grade
    SQL
    DB[:conn].execute(sql, grade).map {|student|  # executes, and creates instances
      self.new_from_db(student)
    }
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
