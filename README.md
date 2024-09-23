# goit-pyweb-hw-06

**1. database_script.py**

```
import sqlite3
from faker import Faker
import random
from datetime import datetime

fake = Faker()

connection = sqlite3.connect('uas.db')
cursor = connection.cursor()

#creating tables
cursor.execute('''
               CREATE TABLE IF NOT EXISTS groups (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT)
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS students (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    group_id INTEGER,
                    FOREIGN KEY(group_id) REFERENCES groups(id))
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS teachers (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT)
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS subjects (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    teacher_id INTEGER,
                    FOREIGN KEY(teacher_id) REFERENCES teachers(id))
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS grades (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    student_id INTEGER,
                    subject_id INTEGER,
                    grade INTEGER,
                    date TEXT,
                    FOREIGN KEY(student_id) REFERENCES students(id),
                    FOREIGN KEY(subject_id) REFERENCES subjects(id))
               ''')

# ADDING DATA TO TABLES

# creating students
for _ in range(42):
    cursor.execute("INSERT INTO students (name, group_id) VALUES (?, ?)", 
                   (fake.name(), random.randint(1, 3)))

# creating groups
group_names = ['Group A', 'Group B', 'Group C']
for name in group_names:
    cursor.execute("INSERT INTO groups (name) VALUES (?)", (name,))

# creating teachers
for _ in range(5):
    cursor.execute("INSERT INTO teachers (name) VALUES (?)", (fake.name(),))

# creating subjects
subject_names = ['Math', 'Physics', 'History', 'Literature', 'Chemistry']
teacher_ids = [1, 2, 3, 4, 5]
for i in range(5):
    cursor.execute("INSERT INTO subjects (name, teacher_id) VALUES (?, ?)", 
                   (subject_names[i], random.choice(teacher_ids)))

# creating grades for each student
student_ids = cursor.execute("SELECT id FROM students").fetchall()
subject_ids = cursor.execute("SELECT id FROM subjects").fetchall()

for student_id in student_ids:
    for _ in range(random.randint(5, 20)):  # limit numbers of student's grade to 20
        subject_id = random.choice(subject_ids)[0]
        grade = random.randint(60, 100)
        date = fake.date_between(start_date='-2y', end_date='today').strftime('%Y-%m-%d')
        cursor.execute("INSERT INTO grades (student_id, subject_id, grade, date) VALUES (?, ?, ?, ?)", 
                       (student_id[0], subject_id, grade, date))

connection.commit()
connection.close()
```

<details>
  <summary><i>query_1.sql</i></summary>

```
SELECT students.name, AVG(grades.grade) AS avg_grade
FROM students
JOIN grades ON students.id = grades.student_id
GROUP BY students.id
ORDER BY avg_grade DESC
LIMIT 5;
```
</details>


