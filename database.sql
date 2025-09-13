CREATE TABLE Programs (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    price NUMERIC NOT NULL,
    program_type VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Modules (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);
CREATE TABLE program_modules (
    program_id BIGINT REFERENCES Programs(id),
    module_id BIGINT REFERENCES Modules(id),
    PRIMARY KEY(program_id, module_id)
);
CREATE TABLE Courses (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);
CREATE TABLE course_modules (
    course_id BIGINT REFERENCES Courses(id),
    module_id BIGINT REFERENCES Modules(id),
    PRIMARY KEY(course_id, module_id)
);
CREATE TABLE Lessons (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id BIGINT REFERENCES Courses(id) DEFAULT 1 NOT NULL,
    name VARCHAR NOT NULL,
    content TEXT NOT NULL,
    video_url TEXT,
    position INT DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);
CREATE TABLE Teaching_Groups (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    slug TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE users_type AS ENUM ('student', 'teacher', 'admin');
CREATE TABLE Users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    teaching_group_id BIGINT REFERENCES Teaching_Groups(id) NOT NULL,
    role users_type NOT NULL,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    password_hash VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
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
    paid_at TIMESTAMP DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE programcompletion_type AS ENUM ('active', 'completed', 'pending', 'cancelled');
CREATE TABLE Program_Completions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    program_id BIGINT REFERENCES Programs(id) NOT NULL,
    status programcompletion_type NOT NULL,
    started_at TIMESTAMP DEFAULT NOW() NOT NULL,
    completed_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Certificates (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    program_id BIGINT REFERENCES Programs(id) NOT NULL,
    url VARCHAR NOT NULL,
    issued_at TIMESTAMP DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Quizzes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NUll,
    name VARCHAR NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Exercises (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NULL,
    name VARCHAR NOT NULL,
    url VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE Discussions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NULL,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE blog_type AS ENUM ('created', 'in moderation', 'published', 'archived');
CREATE TABLE blogs (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id) NOT NULL,
    name VARCHAR NOT NULL,
    content TEXT NOT NULL,
    status blog_type NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);