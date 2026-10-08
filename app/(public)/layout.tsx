import Link from 'next/link';
import { HeartPulse, Menu } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';

export default function PublicLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen flex-col">
      <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container flex h-16 items-center justify-between px-4 md:px-8">
          <Link href="/" className="flex items-center gap-2">
            <HeartPulse className="h-6 w-6 text-primary" />
            <span className="text-xl font-bold">Healix</span>
          </Link>
          
          <nav className="hidden md:flex items-center gap-6">
            <Link href="/" className="text-sm font-medium hover:text-primary transition-colors">Home</Link>
            <Link href="/about" className="text-sm font-medium hover:text-primary transition-colors">About</Link>
            <Link href="/doctors" className="text-sm font-medium hover:text-primary transition-colors">Doctors</Link>
          </nav>

          <div className="hidden md:flex items-center gap-4">
            <Button variant="ghost" >
              <Link href="/login">Log in</Link>
            </Button>
            <Button >
              <Link href="/register">Register</Link>
            </Button>
          </div>

          <Sheet>
            <SheetTrigger >
              <Button variant="outline" size="icon" className="md:hidden">
                <Menu className="h-5 w-5" />
                <span className="sr-only">Toggle Menu</span>
              </Button>
            </SheetTrigger>
            <SheetContent side="right">
              <div className="flex flex-col gap-4 mt-8">
                <Link href="/" className="text-sm font-medium">Home</Link>
                <Link href="/about" className="text-sm font-medium">About</Link>
                <Link href="/doctors" className="text-sm font-medium">Doctors</Link>
                <div className="h-px bg-muted my-2" />
                <Link href="/login" className="text-sm font-medium">Log in</Link>
                <Link href="/register" className="text-sm font-medium">Register</Link>
              </div>
            </SheetContent>
          </Sheet>
        </div>
      </header>
      <main className="flex-1">
        {children}
      </main>
    </div>
  );
}
