export const dynamic = "force-dynamic";
export default function MedicalRecordDetail({ params }: { params: { id: string } }) {
  return <div className="p-6"><h1>Medical Record {params.id}</h1></div>;
}
