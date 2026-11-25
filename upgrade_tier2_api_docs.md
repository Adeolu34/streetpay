# Tier 2 & Tier 3 Upgrade API Documentation (`upgrade2teir2`)

This document provides the endpoint details, headers, parameters, and sample request/response payloads for the **Tier 2 and Tier 3 Wallet Upgrade** API call used in the StreetPay mobile application.

> **Tier 3 Update:** Tier 3 upgrades use service key `theKey: 10000` with target tier `tier: "3"`. Proof of address must be provided in image format (JPEG/PNG) at actual verification size (1024x1448). See Section 7 for details.

---

## 1. Overview

| Property | Details |
| :--- | :--- |
| **API Name** | Wallet Upgrade (`upgradetoteirtwo`) |
| **Endpoint URL** | `https://api.mypingapi.com/sp/myhandler` |
| **HTTP Method** | `POST` |
| **Content-Type** | `multipart/form-data` |
| **Authentication** | Bearer Token (`Authorization: Bearer <accessToken>`) |
| **Service Key (`theKey`)** | `10000` |
| **Target Tier** | `2` (for Tier 2) or `3` (for Tier 3) |

> **Important:** The **ONLY** valid endpoint URL for Tier 2 and Tier 3 upgrades is `https://api.mypingapi.com/sp/myhandler`. Never append any extra path.

---

## 2. Request Headers

```http
POST /sp/myhandler HTTP/1.1
Host: api.mypingapi.com
Authorization: Bearer <AUTH_TOKEN>
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
```

---

## 3. Form-Data Parameters (`multipart/form-data`)

### Text Fields

| Field Name | Type | Required | Sample Value | Description |
| :--- | :--- | :---: | :--- | :--- |
| `theKey` | `String` | **Yes** | `"10000"` | Service routing key for Tier 2 upgrade |
| `tier` | `String` | **Yes** | `"2"` | Target tier level |
| `accountNumber` | `String` | **Yes** | `"1029384756"` | User wallet / virtual account number |
| `accountName` | `String` | **Yes** | `"JOHN DOE"` | Full legal name on the account |
| `bvn` | `String` | **Yes** | `"22233344455"` | 11-digit Bank Verification Number |
| `nin` | `String` | **Yes** | `"12345678901"` | 11-digit National Identity Number |
| `phoneNumber` | `String` | **Yes** | `"2348012345678"` | Phone number with country code prefix |
| `email` | `String` | **Yes** | `"johndoe@example.com"` | Customer valid email address |
| `idType` | `String` | **Yes** | `"1"` | ID Type code (`"1"` for NIN / National ID) |
| `idNumber` | `String` | **Yes** | `"12345678901"` | ID card number (same as NIN) |
| `idIssueDate` | `String` | **Yes** | `"2024-05-12"` | ID issue date in format `YYYY-MM-DD` |
| `houseNumber` | `String` | **Yes** | `"14"` | Residential house / building number |
| `streetName` | `String` | **Yes** | `"Adetokunbo Ademola Street"` | Street address |
| `city` | `String` | **Yes** | `"Victoria Island"` | Residential city |
| `state` | `String` | **Yes** | `"Lagos"` | State of residence |
| `localGovernment`| `String` | **Yes** | `"Eti-Osa"` | Local Government Area (LGA) |
| `pep` | `String` | **Yes** | `"No"` | Politically Exposed Person status (`"Yes"` or `"No"`) |
| `nearestLandmark`| `String` | **Yes** | `"Opposite Eko Hotel"` | Notable landmark close to the address |

### File Upload Fields (Binary Multipart)

| Field Name | Type | Required | MIME Type | Description |
| :--- | :--- | :---: | :--- | :--- |
| `userPhoto` | `File` | **Yes** | `image/jpeg` or `image/png` | Clear passport photo / selfie capture |
| `idCardFront` | `File` | **Yes** | `image/jpeg` or `image/png` | Front view image of NIN card / slip |
| `utilityBill` | `File` | **Yes** | `image/jpeg`, `image/png`, or `application/pdf` | Recent utility bill (electricity, water, waste) |
| `customerSignature` | `File` | **Yes** | `image/png` | Drawn digital signature PNG/JPEG |

---

## 4. cURL Sample Request

```bash
curl --location 'https://api.mypingapi.com/sp/myhandler' \
--header 'Authorization: Bearer YOUR_BEARER_TOKEN' \
--form 'theKey="10000"' \
--form 'tier="2"' \
--form 'accountNumber="1029384756"' \
--form 'accountName="JOHN DOE"' \
--form 'bvn="22233344455"' \
--form 'nin="12345678901"' \
--form 'phoneNumber="2348012345678"' \
--form 'email="johndoe@example.com"' \
--form 'idType="1"' \
--form 'idNumber="12345678901"' \
--form 'idIssueDate="2024-05-12"' \
--form 'houseNumber="14"' \
--form 'streetName="Adetokunbo Ademola Street"' \
--form 'city="Victoria Island"' \
--form 'state="Lagos"' \
--form 'localGovernment="Eti-Osa"' \
--form 'pep="No"' \
--form 'nearestLandmark="Opposite Eko Hotel"' \
--form 'userPhoto=@"/path/to/selfie.jpg"' \
--form 'idCardFront=@"/path/to/nin_card.jpg"' \
--form 'utilityBill=@"/path/to/utility_bill.jpg"' \
--form 'customerSignature=@"/path/to/signature.png"'
```

---

## 5. Postman Body Representation (`form-data`)

| Key | Type | Value |
| :--- | :--- | :--- |
| `theKey` | Text | `10000` |
| `tier` | Text | `2` |
| `accountNumber` | Text | `1029384756` |
| `accountName` | Text | `JOHN DOE` |
| `bvn` | Text | `22233344455` |
| `nin` | Text | `12345678901` |
| `phoneNumber` | Text | `2348012345678` |
| `email` | Text | `johndoe@example.com` |
| `idType` | Text | `1` |
| `idNumber` | Text | `12345678901` |
| `idIssueDate` | Text | `2024-05-12` |
| `houseNumber` | Text | `14` |
| `streetName` | Text | `Adetokunbo Ademola Street` |
| `city` | Text | `Victoria Island` |
| `state` | Text | `Lagos` |
| `localGovernment`| Text | `Eti-Osa` |
| `pep` | Text | `No` |
| `nearestLandmark`| Text | `Opposite Eko Hotel` |
| `userPhoto` | File | `[Select passport/selfie image]` |
| `idCardFront` | File | `[Select NIN slip/card front image]` |
| `utilityBill` | File | `[Select utility bill image]` |
| `customerSignature` | File | `[Select digital signature image]` |

---

## 6. Sample Responses

### A. Success Response (`200 OK`)

```json
{
  "Success": true,
  "Message": "Tier 2 upgrade submitted successfully. Documents under review.",
  "data": {
    "accountNumber": "1029384756",
    "tier": "2",
    "status": "PENDING_VERIFICATION"
  }
}
```

### B. Validation / Failure Response (`400 Bad Request` or `Success: false`)

```json
{
  "Success": false,
  "Message": "BVN or NIN validation failed. Details do not match national identity registry.",
  "fieldErrors": [
    {
      "field": "bvn",
      "message": "BVN records mismatch"
    }
  ]
}
```

---

## 7. Tier 3 Wallet Upgrade (`theKey: 10000`)

Tier 3 upgrades are routed using service key `theKey: 10000` with target tier `tier: "3"`.

| Property | Details |
| :--- | :--- |
| **API Name** | Tier 3 Upgrade (`upgradetotierthree`) |
| **Endpoint URL** | `https://api.mypingapi.com/sp/myhandler` |
| **HTTP Method** | `POST` |
| **Content-Type** | `multipart/form-data` |
| **Authentication** | Bearer Token (`Authorization: Bearer <accessToken>`) |
| **Service Key (`theKey`)** | `10000` |
| **Target Tier (`tier`)** | `3` |

### Parameters (Multipart Form-Data)

#### Text Fields

| Parameter | Type | Required | Description |
| :--- | :--- | :---: | :--- |
| `theKey` | `String` | **Yes** | Service routing key `"10000"` |
| `tier` | `String` | **Yes** | Target tier level `"3"` |
| `accountNumber` | `String` | **Yes** | User wallet / virtual account number |
| `bvn` | `String` | **Yes** | 11-digit Bank Verification Number |
| `nin` | `String` | **Yes** | 11-digit National Identity Number |
| `idType` | `String` | **Yes** | ID type code `"1"` (National ID / NIN) |
| `idNumber` | `String` | **Yes** | 11-digit NIN number (held in ID number slot) |
| `accountName` | `String` | Optional | Full legal name on the account |
| `phoneNumber` | `String` | Optional | User phone number with country code prefix |
| `email` | `String` | Optional | Customer valid email address |
| `idIssueDate` | `String` | Optional | ID issue date in format `YYYY-MM-DD` |
| `idExpiryDate` | `String` | Optional | ID expiry date in format `YYYY-MM-DD` |
| `houseNumber` | `String` | Optional | Residential house / building number |
| `streetName` | `String` | Optional | Street address |
| `city` | `String` | Optional | Residential city |
| `state` | `String` | Optional | State of residence |
| `localGovernment` | `String` | Optional | Local Government Area (LGA) |
| `pep` | `String` | Optional | Politically Exposed Person status (`"Yes"` or `"No"`) |
| `nearestLandmark` | `String` | Optional | Notable landmark close to the address |

#### File Upload Fields (Binary Multipart)

| Field Name | Type | Required | Description |
| :--- | :--- | :---: | :--- |
| `proofOfAddressVerification` | `File` | **Yes** | Proof of address image (JPEG/PNG) at actual verification size |
| `proofaddress` | `File` | Optional | Alias for `proofOfAddressVerification` |
| `utilityBill` | `File` | Optional | Utility bill document image (JPEG/PNG) |
| `customerSignature` | `File` | Optional | Drawn digital signature PNG/JPEG |
| `userPhoto` | `File` | Optional | Clear passport photo / selfie capture |
| `idCardFront` | `File` | Optional | Front view image of NIN card / slip |

### Critical Requirement: Proof of Address Image Format
- The proof of address MUST be an **image format** (JPEG/PNG, not PDF).
- Auto-generated verification forms render to high-resolution canvas at actual verification size (1024x1448) with zero blur and high visual fidelity.

### Sample cURL Request

```bash
curl --location 'https://api.mypingapi.com/sp/myhandler' \
--header 'Authorization: Bearer YOUR_BEARER_TOKEN' \
--form 'theKey="10000"' \
--form 'tier="3"' \
--form 'accountNumber="1100767497"' \
--form 'bvn="22534258964"' \
--form 'nin="12345678901"' \
--form 'idType="1"' \
--form 'idNumber="12345678901"' \
--form 'accountName="JOHN DOE"' \
--form 'phoneNumber="2348012345678"' \
--form 'email="johndoe@example.com"' \
--form 'streetName="Adetokunbo Ademola Street"' \
--form 'city="Victoria Island"' \
--form 'state="Lagos"' \
--form 'localGovernment="Eti-Osa"' \
--form 'pep="No"' \
--form 'nearestLandmark="Opposite Eko Hotel"' \
--form 'proofOfAddressVerification=@"/path/to/address_verification.jpg"' \
--form 'utilityBill=@"/path/to/utility_bill.jpg"' \
--form 'customerSignature=@"/path/to/signature.png"'
```


