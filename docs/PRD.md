# Product Requirement Document (PRD) — Healix

## 1. Vision & Purpose
Healix is an enterprise-grade, role-based Online Healthcare Management System engineered to streamline operations across patients, doctors, and system administrators.

## 2. Core Personas & Roles
- **Patient**: Discover doctors, book conflict-free appointment slots, review medical charts, and rate care.
- **Doctor**: Define shift schedules, accept/complete appointments, record diagnoses and treatment notes.
- **Admin**: Oversee platform rosters, inspect audit logs, view usage metrics, configure clinic operational bounds.

## 3. Architecture
- **Framework**: Next.js App Router (TypeScript)
- **Styling**: Tailwind CSS + shadcn/ui + Lucide
- **Database & Auth**: Supabase PostgreSQL with Row Level Security (RLS)
