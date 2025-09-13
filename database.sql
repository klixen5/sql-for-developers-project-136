CREATE TABLE Programs (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR UNIQUE NOT NULL,
    price NUMERIC NOT NULL,
    type VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Modules (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    program_id BIGINT REFERENCES Programs(id) NOT NULL,
    title VARCHAR NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(program_id, title)
);

CREATE TABLE Courses (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    module_id BIGINT REFERENCES Modules(id) NOT NULL,
    title VARCHAR NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(module_id, title)
);
CREATE TABLE Lessons (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id BIGINT REFERENCES Courses(id) NOT NULL,
    title VARCHAR NOT NULL,
    body TEXT NOT NULL,
    url_video TEXT,
    position INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(course_id, position)
);
CREATE TABLE TeachingGroups (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    slug TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE users_type AS ENUM ('student', 'teacher', 'admin');
CREATE TABLE Users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    group_id BIGINT REFERENCES TeachingGroups(id) NOT NULL,
    type users_type NOT NULL,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    password VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE enrollments_type AS ENUM ('active', 'pending', 'cancelled', 'completed');
CREATE TABLE Enrollments (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    program_id BIGINT REFERENCES Programs(id) NOT NULL,
    UNIQUE(user_id, program_id),
    status enrollments_type NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE payments_type AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TABLE Payments (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    enrollment_id BIGINT REFERENCES Enrollments(id) NOT NULL,
    amount NUMERIC NOT NULL,
    status payments_type NOT NULL,
    date TIMESTAMP DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE programcompletion_type AS ENUM ('active', 'completed', 'pending', 'cancelled');
CREATE TABLE ProgramCompletions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    program_id BIGINT REFERENCES Programs(id) NOT NULL,
    status programcompletion_type NOT NULL,
    start_time TIMESTAMP DEFAULT NOW() NOT NULL,
    finish_time TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Certificates (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    program_id BIGINT REFERENCES Programs(id) NOT NULL,
    certificate_url VARCHAR NOT NULL,
    certificate_created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Quizzes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NUll,
    title VARCHAR NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Exercises (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NULL,
    title VARCHAR NOT NULL,
    url_pr VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Discussions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE blog_type AS ENUM ('created', 'in moderation', 'published', 'archived');
CREATE TABLE Blog (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    title VARCHAR NOT NULL,
    body TEXT NOT NULL,
    status blog_type NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);