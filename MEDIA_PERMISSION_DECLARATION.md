# Media Permission Declaration (Photos & Videos)

## Google Play Console Declaration

When prompted in the **Google Play Console** under **App content > Photos and videos permissions** (or Permissions declaration form for `READ_MEDIA_IMAGES` and `READ_MEDIA_VIDEO`), use the following details:

### 1. Core Feature Description / Permission Note:
> **Our app allows users to verify and update their profile by uploading photos or videos. These media files are encrypted on the device before upload to protect user privacy. This operation is infrequent and occurs only at user request.**

---

### 2. Declaration Checklist & Key Answers:

* **Why does your app need access to photos/videos?**
  * Account verification (KYC Tier 2 and Tier 3 identity verification).
  * Profile photo update.
  * Document verification and proof of address.
* **Is the permission request user-initiated?**
  * **Yes**. Media access is only requested when the user explicitly taps to upload an ID document, proof of address, or update their profile photo.
* **How often is this feature used?**
  * **Infrequent / One-time**. Only during onboarding, KYC tier verification, or occasional profile updates.
* **Data Protection & Privacy:**
  * Files are processed and encrypted on-device before secure transmission to compliance servers.
  * StreetPay does not access, browse, or sync photos/videos in the background.

---

### 3. Implementation in Codebase:

1. **In-App Prominent Disclosure**:
   * Located in `lib/flutter_flow/upload_data.dart` inside the media selection bottom sheet. Users see the security and encryption disclosure before selecting photos/videos.
2. **Android String Resource**:
   * Defined in `android/app/src/main/res/values/strings.xml` as `media_permission_note`.
3. **iOS Info.plist**:
   * Defined under `NSPhotoLibraryUsageDescription` in `ios/Runner/Info.plist`.
