import { HeartPulse } from 'lucide-react';
import Link from 'next/link';

export default function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-muted/30 flex flex-col justify-center items-center p-4">
      <Link href="/" className="flex items-center gap-2 mb-8">
        <HeartPulse className="h-8 w-8 text-primary" />
        <span className="text-2xl font-bold tracking-tight">Healix</span>
      </Link>
      {children}
    </div>
  );
}
