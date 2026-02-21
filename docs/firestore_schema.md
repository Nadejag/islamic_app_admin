# Firestore Schema (Core Collections)

All docs include:
- `status` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)
- `createdBy` (string, optional for system-generated docs)

## Collections

1. `users/{uid}`
- `name`, `email`, `verified`, `banned`, `lastActiveAt`, `streak`

2. `admins/{uid}`
- `role` (`super_admin|admin|scholar`), `name`, `email`, `isActive`

3. `scholars/{uid}`
- `badge`, `bio`, `specialization`, `verifiedAt`

4. `scholar_requests/{id}`
- `userId`, `documents[]`, `certificates[]`, `bio`, `reviewNotes`, `decisionReason`

5. `charity_requests/{id}`
- `title`, `targetAmount`, `description`, `proofDocs[]`, `verificationBadge`

6. `donations/{id}`
- `userId`, `charityRequestId`, `amount`, `currency`, `paymentRef`, `riskFlag`

7. `hadith/{id}`
- `text`, `source`, `authenticity`, `topic`, `enabled`

8. `tafseer/{id}`
- `source`, `surah`, `ayah`, `content`, `enabled`

9. `quran_surah/{id}`
- `surahNumber`, `nameArabic`, `nameEnglish`, `audioUrl`, `enabled`

10. `daily_inspiration/{id}`
- `type` (`ayah|hadith`), `contentRef`, `publishAt`, `archived`

11. `islamic_events/{id}`
- `name`, `hijriDate`, `gregorianDate`, `highlighted`, `notificationsEnabled`

12. `reports/{id}`
- `type`, `targetId`, `details`, `reporterId`, `assignedAdminId`, `resolution`

13. `admin_logs/{id}`
- `adminId`, `action`, `target`, `before`, `after`, `metadata`

14. `classes/{id}`
- `teacherId`, `title`, `live`, `enrollmentCount`, `rating`

15. `reviews/{id}`
- `classId`, `userId`, `rating`, `comment`

16. `certificates/{id}`
- `classId`, `userId`, `approved`, `approvedBy`

17. `ai_questions/{id}`
- `userId`, `question`, `response`, `topic`, `flagged`, `misuseScore`

18. `settings/app`
- `aiDisclaimer`, `communityRules`, `privacyPolicy`, `terms`, `versionInfo`, `notificationTemplates`
