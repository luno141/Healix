import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { CalendarCheck, Shield, Users, Clock } from 'lucide-react';
import Link from 'next/link';

export default function LandingPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <section className="w-full py-24 md:py-32 lg:py-40 bg-muted/30">
        <div className="container px-4 md:px-6 mx-auto text-center">
          <h1 className="text-4xl md:text-6xl font-bold tracking-tighter mb-6">
            Modern Healthcare <br className="hidden sm:inline" />
            <span className="text-primary">Management System</span>
          </h1>
          <p className="mx-auto max-w-[700px] text-muted-foreground md:text-xl mb-10">
            Streamline your medical practice, book appointments easily, and manage patient records securely with Healix.
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Button size="lg" >
              <Link href="/register">Get Started</Link>
            </Button>
            <Button size="lg" variant="outline" >
              <Link href="/login">Sign In</Link>
            </Button>
          </div>
        </div>
      </section>

      <section className="w-full py-20 bg-background">
        <div className="container px-4 md:px-6 mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold tracking-tighter sm:text-4xl">Why Choose Healix?</h2>
            <p className="mt-4 text-muted-foreground md:text-lg">Everything you need to manage your healthcare journey.</p>
          </div>
          
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <Card>
              <CardHeader className="flex flex-row items-center gap-4 pb-2">
                <div className="p-2 bg-primary/10 rounded-lg">
                  <CalendarCheck className="w-6 h-6 text-primary" />
                </div>
                <CardTitle className="text-xl">Easy Booking</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">Schedule appointments with your preferred doctors seamlessly.</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center gap-4 pb-2">
                <div className="p-2 bg-primary/10 rounded-lg">
                  <Users className="w-6 h-6 text-primary" />
                </div>
                <CardTitle className="text-xl">Expert Doctors</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">Access a wide network of verified and experienced specialists.</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center gap-4 pb-2">
                <div className="p-2 bg-primary/10 rounded-lg">
                  <Shield className="w-6 h-6 text-primary" />
                </div>
                <CardTitle className="text-xl">Secure Records</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">Your medical history is protected with enterprise-grade security.</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="flex flex-row items-center gap-4 pb-2">
                <div className="p-2 bg-primary/10 rounded-lg">
                  <Clock className="w-6 h-6 text-primary" />
                </div>
                <CardTitle className="text-xl">24/7 Access</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">Access your health records and manage appointments anytime.</p>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      <footer className="w-full py-6 border-t mt-auto">
        <div className="container px-4 md:px-6 mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-sm text-muted-foreground">
            © 2024 Healix Healthcare. All rights reserved.
          </p>
          <div className="flex gap-4">
            <Link href="#" className="text-sm text-muted-foreground hover:underline">Terms</Link>
            <Link href="#" className="text-sm text-muted-foreground hover:underline">Privacy</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
