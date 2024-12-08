-- Migrations will appear here as you chat with AI
create table todos (
  id bigint primary key generated always as identity,
  title text not null,
  description text,
  due_date date,
  is_completed boolean default false
);

-- Migration data
insert into
  todos (title, description, due_date, is_completed)
values
  (
    'Buy groceries',
    'Milk, Bread, Cheese, and Eggs',
    '2023-11-01',
    false
  ),
  (
    'Finish project report',
    'Complete the final report for the project',
    '2023-11-05',
    false
  ),
  (
    'Call plumber',
    'Fix the leaking sink in the kitchen',
    '2023-11-02',
    false
  ),
  (
    'Book flight tickets',
    'Book tickets for the upcoming vacation',
    '2023-11-10',
    false
  ),
  (
    'Schedule dentist appointment',
    'Routine check-up and cleaning',
    '2023-11-03',
    false
  ),
  (
    'Prepare presentation',
    'Prepare slides for the upcoming meeting',
    '2023-11-04',
    false
  ),
  (
    'Renew car insurance',
    'Renew the insurance policy before it expires',
    '2023-11-06',
    false
  ),
  (
    'Organize garage',
    'Clean and organize the garage space',
    '2023-11-07',
    false
  ),
  (
    'Plan birthday party',
    'Plan a surprise birthday party for a friend',
    '2023-11-08',
    false
  ),
  (
    'Read new book',
    'Start reading the new book purchased last week',
    '2023-11-09',
    false
  );