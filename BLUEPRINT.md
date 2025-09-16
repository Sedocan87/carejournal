# carejournal

Project Blueprint: "CareJournal" - A Privacy-First Health Companion
This document outlines the development plan for CareJournal, a Flutter-based mobile application designed as a secure, private, and non-algorithmic digital health journal for individuals managing chronic conditions.

1. App Concept and Guiding Philosophy
1.1. The Core Idea
CareJournal is a digital vault for a user's health story. It empowers patients with chronic illnesses to manually log, manage, and understand their health data without fear of their information being collected, analyzed, or sold. The app's core function is to be a simple, trustworthy tool for tracking health events and preparing for medical appointments.

Target Audience: Individuals managing chronic conditions such as autoimmune diseases, long COVID, chronic pain, diabetes, and other complex health needs. These users require meticulous record-keeping and have a high sensitivity to data privacy.

Core Value Proposition: "Your health story, in your control." The app is built on three pillars:

Absolute Privacy: All data is stored and processed exclusively on the user's device. Nothing is ever sent to a server.

User Empowerment: The app provides tools for self-discovery, not algorithmic prescriptions. It helps users see their own patterns.

Practical Utility: The "Doctor's Report" feature solves a critical pain point by transforming personal logs into a clear, actionable summary for healthcare providers.

1.2. Guiding Principles: Privacy by Design (PbD)
The entire development process will be governed by the seven principles of Privacy by Design. This is not an afterthought; it is the foundation of the architecture.  

Proactive, not Reactive: We will build security in from the start, not patch it in later.

Privacy as the Default: The app will collect the absolute minimum data necessary to function. All privacy-enhancing features will be on by default.  

Privacy Embedded into Design: The on-device architecture is a direct embodiment of this principle.  

Full Functionality (Positive-Sum): The absence of cloud features is presented as a benefit: enhanced speed, offline capability, and ultimate privacy.  

End-to-End Security: Data is encrypted from the moment it's created until the user chooses to delete it.  

Visibility and Transparency: The app's UI and privacy policy will be clear, honest, and written in plain language.  

User-Centric: The user is the sole owner and controller of their data. The app will provide easy tools to manage, export, and delete it.  

2. Technical Architecture & Specifications
The app will be built using Flutter for cross-platform compatibility (iOS and Android) from a single codebase. The architecture is designed to be serverless from a user-data perspective.

Component	Technology/Package	Rationale & Implementation Notes
Framework	Flutter SDK	Enables cross-platform development for iOS and Android.
Local Database	sqflite_sqlcipher  	Provides a local SQLite database with robust, industry-standard AES-256 encryption. This is the core of our on-device storage strategy, ensuring all health data is encrypted at rest.
Encryption Key Storage	flutter_secure_storage  	Securely stores the database encryption key in the platform's native secure storage: Keychain for iOS and Keystore for Android. This prevents the key from being easily extracted.
App Lock (Optional)	local_auth  	Allows the user to lock the app with their device's biometric authentication (Face ID, Touch ID, Fingerprint) or passcode, adding a crucial layer of security if the device is lost or shared.
PDF Generation	pdf  	A powerful library for creating PDF documents directly on the device. It uses a widget-based system, making it intuitive for a Flutter developer to build the "Doctor's Report" layout.
File System Access	path_provider  	Used to find the correct, secure directory on the device's file system to store the encrypted database and any generated reports.
Data Export (CSV)	to_csv or csv  	To implement the "Export All Data" feature, allowing users to get a full backup of their information in an open, accessible format.
Sharing	share_plus	To invoke the native OS sharing dialog, allowing the user to securely send their generated PDF or CSV reports via email, AirDrop, or other services without the app needing network permissions.
Photo Integration	image_picker	To allow users to select photos from their gallery or take a new one to attach to log entries (e.g., a picture of a rash or a meal).
Data Visualization	fl_chart	For creating charts and graphs to visualize health data over time.
Backup Encryption	encrypt	To encrypt and decrypt the database for the secure backup and restore feature.
File Selection	file_picker	To allow the user to select a backup file to restore from.

3. Core Feature Implementation Plan
Feature 1: Unified Health Log (Done)
This is the main screen of the app—a chronological timeline of all user-entered data.

Data Model: A single log_entries table in the SQLite database.

id (INTEGER, PRIMARY KEY)

timestamp (TEXT, ISO 8601 format)

entry_type (TEXT: 'symptom', 'note', 'photo')

title (TEXT, e.g., "Headache")

data (TEXT, JSON-encoded string for flexible data like {"severity": 7, "location": "temples"} or {"path": "/path/to/image.jpg"})

notes (TEXT, optional user-written details)

report_tag (INTEGER, boolean flag for inclusion in the Doctor's Report)

Implementation:

-   **Done:** Build a ListView.builder with ExpansionTiles to display entries fetched from the database.
-   **Done:** Create a Floating Action Button that opens a dedicated "Add Entry" screen.
-   **Done:** On the "Add Entry" screen, a dropdown allows users to select the entry type ('Note', 'Symptom', 'Photo').
-   **Done:** For 'Symptom' entries, UI elements for severity (slider) and location (text field) are available.
-   **Done:** For 'Photo' entries, use image_picker to select an image and store its path.
-   **Done:** A search bar is implemented to filter the timeline.

Feature 2: "Doctor's Report" Generator (Done)
The app's killer feature. It generates a clean, professional PDF summary on-device.

Implementation:

-   **Done:** The user can export all data to PDF or CSV from the main menu.
-   **Done:** On "Generate," query the local database for the relevant log_entries.
-   **Done:** Use the pdf package to construct the document.
-   **Done:** Use share_plus to let the user share or save the file.

Feature 3: Data Visualization (Done)
A dashboard screen to help users visualize their health data.

Implementation:

-   **Done:** A "Dashboard" screen is accessible from the timeline.
-   **Done:** It fetches all 'symptom' entries.
-   **Done:** It uses the fl_chart package to display a line chart of symptom severity over time.

Feature 4: Secure Backup and Restore (Done)
A secure, user-controlled backup and restore mechanism.

Implementation:

-   **Done:** "Backup" and "Restore" options are available in the main menu.
-   **Done:** Backups are encrypted with a user-provided password using the `encrypt` package.
-   **Done:** The `share_plus` package is used to export the encrypted backup file.
-   **Done:** The `file_picker` package is used to import a backup file for restoration.
-   **Done:** The app prompts the user to restart after a successful restore.

Feature 5: Data Management & Accessibility
Empowering users with control and ensuring the app is usable by everyone.

Data Export:

-   **Done:** Provide "Export All Data to CSV" and "Export to PDF" buttons in the main menu.

Accessibility (A11y): This is a top priority for the target audience.

-   **Partially Done:** The app respects system font size scaling and has good contrast with the light/dark themes. Further auditing is required.

4. Phased Implementation Plan
This is a suggested timeline for a solo developer or small team.

Phase 1: Foundation & Core Logic (Done)

-   **Done:** Project setup, all dependencies added, Git repository initialized.
-   **Done:** Implement the secure database architecture. Create a DatabaseHelper class that handles key generation/retrieval (flutter_secure_storage) and database initialization/encryption (sqflite_sqlcipher). Define all data models.
-   **Done:** Build the main timeline UI and the forms for adding/editing basic log entries.

Phase 2: Feature Expansion (Done)

-   **Done:** Implement the "Doctor's Report" PDF generation and sharing functionality.
-   **Done:** Add the photo journal feature.
-   **Done:** Implement the full data export to CSV feature.
-   **Done:** Implement search and filtering.
-   **Done:** Implement data visualization.
-   **Done:** Implement secure backup and restore.

Phase 3: Polish & Testing (In Progress)

-   **In Progress:** UI/UX refinement, adding animations, and ensuring a smooth user flow.
-   **To Do:** Conduct a full accessibility audit. Implement all necessary Semantics, check contrast ratios, and test with TalkBack and VoiceOver.
-   **To Do:** Implement the optional biometric app lock.

Phase 4: Deployment (To Do)

-   **To Do:** Write the plain-language privacy policy. Prepare App Store and Google Play Store listings.
-   **To Do:** Final round of testing on physical devices. Beta test with a small group of target users if possible. Submit for review.

5. Privacy Policy Requirements
Even though the app does not collect user data, a privacy policy is required by the app stores. The policy must be easily accessible within the app and on the store listing.  

Key points to include:

Explicit Statement: "CareJournal does not collect, store, transmit, or share any of your personal health information. All data you enter is stored exclusively on your own device."

Data Storage Explanation: "Your data is saved in a database on your phone that is protected with strong, industry-standard AES-256 encryption."

Data Ownership: "You are the sole owner of your data. CareJournal provides tools for you to export or delete your data at any time."

Contact Information: Provide an email address for any privacy-related questions.