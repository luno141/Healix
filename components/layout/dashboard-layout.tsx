import { Sidebar } from './sidebar';
import { Header } from './header';

type Role = 'admin' | 'doctor' | 'patient';

export function DashboardLayout({
  children,
  role
}: {
  children: React.ReactNode;
  role: Role;
}) {
  return (
    <div className="flex h-screen bg-muted/20 overflow-hidden">
      <div className="hidden md:flex h-full">
        <Sidebar role={role} />
      </div>
      <div className="flex flex-col flex-1 overflow-hidden">
        <Header role={role} />
        <main className="flex-1 overflow-y-auto p-4 md:p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
