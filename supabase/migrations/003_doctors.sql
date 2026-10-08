-- Create doctors table
CREATE TABLE doctors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    specialization TEXT NOT NULL,
    experience_years INTEGER NOT NULL DEFAULT 0,
    education TEXT NOT NULL,
    license_number TEXT NOT NULL UNIQUE,
    bio TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status TEXT NOT NULL CHECK (status IN ('active', 'inactive', 'pending')) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(profile_id)
);
