import pg from 'pg';

const connectionString = 'postgresql://postgres.gjvwnabfommajpsgneud:vrvU5vFd6U3MBpwY@aws-0-ap-southeast-2.pooler.supabase.com:6543/postgres';
const client = new pg.Client({ connectionString, ssl: { rejectUnauthorized: false } });

async function setup() {
  await client.connect();

  // Create a BEFORE INSERT trigger on auth.users to auto-confirm new registrations
  await client.query(`
    CREATE OR REPLACE FUNCTION auth.auto_confirm_user()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.email_confirmed_at := COALESCE(NEW.email_confirmed_at, NOW());
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    DROP TRIGGER IF EXISTS on_auth_user_before_insert ON auth.users;
    CREATE TRIGGER on_auth_user_before_insert
      BEFORE INSERT ON auth.users
      FOR EACH ROW EXECUTE FUNCTION auth.auto_confirm_user();
  `);

  console.log("Auto-confirmation trigger installed on auth.users!");
  await client.end();
}
setup();
