USE todolist;

CREATE TABLE tasks (
    id int(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title varchar(128) NOT NULL,
    completed BOOLEAN NOT NULL,
    creation_date DATETIME,
    due_date DATETIME
    is_child BOOLEAN NOT NULL,
    parent_task INT UNSIGNED
);