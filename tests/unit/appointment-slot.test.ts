import { describe, it, expect } from 'vitest';

function calculateSlots(startTime: string, endTime: string, slotDuration: number, bookedSlots: string[]) {
  const [startH, startM] = startTime.split(':').map(Number);
  const [endH, endM] = endTime.split(':').map(Number);

  let currentMin = startH * 60 + startM;
  const endMin = endH * 60 + endM;
  const bookedSet = new Set(bookedSlots);

  const available: string[] = [];
  while (currentMin + slotDuration <= endMin) {
    const h = Math.floor(currentMin / 60).toString().padStart(2, '0');
    const m = (currentMin % 60).toString().padStart(2, '0');
    const slot = `${h}:${m}`;
    if (!bookedSet.has(slot)) {
      available.push(slot);
    }
    currentMin += slotDuration;
  }
  return available;
}

describe('Appointment Booking Slot Algorithm', () => {
  it('generates correct slot intervals for doctor shift', () => {
    const slots = calculateSlots('09:00', '11:00', 30, []);
    expect(slots).toEqual(['09:00', '09:30', '10:00', '10:30']);
  });

  it('excludes already booked slots to prevent double-booking', () => {
    const slots = calculateSlots('09:00', '11:00', 30, ['09:30', '10:30']);
    expect(slots).toEqual(['09:00', '10:00']);
  });

  it('handles irregular durations like 45-minute slots', () => {
    const slots = calculateSlots('10:00', '12:00', 45, []);
    expect(slots).toEqual(['10:00', '10:45']);
  });

  it('returns empty array when shift has zero duration', () => {
    const slots = calculateSlots('09:00', '09:00', 30, []);
    expect(slots).toEqual([]);
  });
});
