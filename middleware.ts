import { NextResponse, type NextRequest } from 'next/server'
import { updateSession } from './lib/supabase/middleware'

export async function middleware(request: NextRequest) {
  const { supabaseResponse, user, supabase } = await updateSession(request)

  const path = request.nextUrl.pathname
  const publicRoutes = ['/', '/about', '/doctors', '/login', '/register', '/forgot-password', '/reset-password']

  // Allow public routes and static assets
  if (
    publicRoutes.includes(path) || 
    path.startsWith('/doctors/') ||
    path.startsWith('/_next/') || 
    path.includes('.')
  ) {
    return supabaseResponse
  }

  // Redirect to login if unauthenticated and trying to access protected routes
  if (!user && (path.startsWith('/patient') || path.startsWith('/doctor') || path.startsWith('/admin'))) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  if (user) {
    // Fetch profile to get role
    const { data: profile } = await supabase
      .from('Profile')
      .select('role')
      .eq('id', user.id)
      .single()

    const role = profile?.role

    // Redirect based on role mismatch
    if (path.startsWith('/patient') && role !== 'patient') {
      return NextResponse.redirect(new URL(`/${role}/dashboard`, request.url))
    }
    if (path.startsWith('/doctor') && role !== 'doctor') {
      return NextResponse.redirect(new URL(`/${role}/dashboard`, request.url))
    }
    if (path.startsWith('/admin') && role !== 'admin') {
      return NextResponse.redirect(new URL(`/${role}/dashboard`, request.url))
    }
    
    // Auth users visiting login/register redirect to dashboard
    if (path === '/login' || path === '/register') {
       return NextResponse.redirect(new URL(`/${role || 'patient'}/dashboard`, request.url))
    }
  }

  return supabaseResponse
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
