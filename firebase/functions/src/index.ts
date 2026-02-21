import * as admin from 'firebase-admin';
import { HttpsError, onCall } from 'firebase-functions/v2/https';

admin.initializeApp();

const db = admin.firestore();

async function assertAdmin(uid?: string) {
  if (!uid) throw new HttpsError('unauthenticated', 'Authentication required.');
  const snap = await db.collection('admins').doc(uid).get();
  const role = snap.data()?.role;
  if (role !== 'admin' && role !== 'super_admin') {
    throw new HttpsError('permission-denied', 'Admin role required.');
  }
  return role as string;
}

async function writeAdminLog(params: {
  adminId: string;
  action: string;
  target: string;
  before?: unknown;
  after?: unknown;
}) {
  await db.collection('admin_logs').add({
    adminId: params.adminId,
    action: params.action,
    target: params.target,
    before: params.before ?? null,
    after: params.after ?? null,
    status: 'completed',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    createdBy: params.adminId,
  });
}

export const approveScholar = onCall(async (request) => {
  const uid = request.auth?.uid;
  await assertAdmin(uid);
  const requestId = request.data.requestId as string;
  if (!requestId) throw new HttpsError('invalid-argument', 'requestId is required.');

  const reqRef = db.collection('scholar_requests').doc(requestId);
  const reqSnap = await reqRef.get();
  if (!reqSnap.exists) throw new HttpsError('not-found', 'Scholar request not found.');
  const data = reqSnap.data()!;

  await db.runTransaction(async (tx) => {
    tx.update(reqRef, {
      status: 'approved',
      reviewedBy: uid,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    tx.set(
      db.collection('scholars').doc(data.userId),
      {
        userId: data.userId,
        badge: true,
        bio: data.bio ?? '',
        status: 'active',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
    tx.set(
      db.collection('admins').doc(data.userId),
      {
        role: 'scholar',
        isActive: true,
        status: 'active',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  });

  await writeAdminLog({
    adminId: uid!,
    action: 'approve_scholar',
    target: `scholar_requests/${requestId}`,
    before: reqSnap.data(),
    after: { status: 'approved' },
  });
  return { ok: true };
});

export const resolveReport = onCall(async (request) => {
  const uid = request.auth?.uid;
  await assertAdmin(uid);
  const reportId = request.data.reportId as string;
  const action = request.data.action as string;
  if (!reportId || !action) throw new HttpsError('invalid-argument', 'reportId and action required.');

  const ref = db.collection('reports').doc(reportId);
  const before = (await ref.get()).data();
  await ref.update({
    status: 'resolved',
    resolution: action,
    resolvedBy: uid,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  await writeAdminLog({
    adminId: uid!,
    action: 'resolve_report',
    target: `reports/${reportId}`,
    before,
    after: { status: 'resolved', resolution: action },
  });
  return { ok: true };
});

export const updateSystemSetting = onCall(async (request) => {
  const uid = request.auth?.uid;
  await assertAdmin(uid);
  const key = request.data.key as string;
  const value = request.data.value;
  if (!key) throw new HttpsError('invalid-argument', 'key is required.');

  const ref = db.collection('settings').doc('app');
  const before = (await ref.get()).data();
  await ref.set(
    {
      [key]: value,
      status: 'active',
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdBy: uid,
    },
    { merge: true },
  );
  await writeAdminLog({
    adminId: uid!,
    action: 'update_setting',
    target: `settings/app.${key}`,
    before,
    after: { [key]: value },
  });
  return { ok: true };
});
