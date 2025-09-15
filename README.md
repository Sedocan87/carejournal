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
Local Database	
sqflite_sqlcipher    

Provides a local SQLite database with robust, industry-standard AES-256 encryption. This is the core of our on-device storage strategy, ensuring all health data is encrypted at rest.
Encryption Key Storage	
flutter_secure_storage    

Securely stores the database encryption key in the platform's native secure storage: Keychain for iOS and Keystore for Android. This prevents the key from being easily extracted.
App Lock (Optional)	
local_auth    

Allows the user to lock the app with their device's biometric authentication (Face ID, Touch ID, Fingerprint) or passcode, adding a crucial layer of security if the device is lost or shared.
PDF Generation	
pdf    

A powerful library for creating PDF documents directly on the device. It uses a widget-based system, making it intuitive for a Flutter developer to build the "Doctor's Report" layout.
File System Access	
path_provider    

Used to find the correct, secure directory on the device's file system to store the encrypted database and any generated reports.
Data Export (CSV)	
to_csv or csv    

To implement the "Export All Data" feature, allowing users to get a full backup of their information in an open, accessible format.
Sharing	share_plus	To invoke the native OS sharing dialog, allowing the user to securely send their generated PDF or CSV reports via email, AirDrop, or other services without the app needing network permissions.
Photo Integration	image_picker	To allow users to select photos from their gallery or take a new one to attach to log entries (e.g., a picture of a rash or a meal).
3. Core Feature Implementation Plan
Feature 1: Unified Health Log
This is the main screen of the app—a chronological timeline of all user-entered data.

Data Model: A single log_entries table in the SQLite database.

id (INTEGER, PRIMARY KEY)

timestamp (TEXT, ISO 8601 format)

entry_type (TEXT: 'symptom', 'medication', 'food', 'activity', 'note', 'photo')

title (TEXT, e.g., "Headache" or "Ibuprofen")

data (TEXT, JSON-encoded string for flexible data like {"severity": 7, "location": "temples"} or {"dosage": "200mg"})

notes (TEXT, optional user-written details)

report_tag (INTEGER, boolean flag for inclusion in the Doctor's Report)

Implementation:

Build a ListView.builder to display entries fetched from the database.

Create a Floating Action Button that opens a dialog to select the entry type.

Develop separate, simple input forms for each entry type.

For photos, use image_picker and save the image to the app's private directory obtained via path_provider. Store the file path in the database.

Feature 2: "Doctor's Report" Generator
The app's killer feature. It generates a clean, professional PDF summary on-device.

Implementation:

Create a UI where the user can select specific entries to include (using the report_tag flag) or select a date range.

On "Generate," query the local database for the relevant log_entries.

Use the pdf package to construct the document.   

Create a title page with the patient's name (stored in non-sensitive shared_preferences) and the date range.

Iterate through the query results, using the pdf package's widget-like components (pw.Column, pw.Text, pw.Table) to format each entry chronologically.

Save the generated PDF to a temporary directory using path_provider.   

Use share_plus to let the user share or save the file.

Feature 3: Data Management & Accessibility
Empowering users with control and ensuring the app is usable by everyone.

Data Export:

Provide an "Export All Data to CSV" button in settings.

Query all data from the database, format it into a List<List<String>>, and use the to_csv package to generate the file.   

Use share_plus for exporting.

Accessibility (A11y): This is a top priority for the target audience.

Semantic Labels: Wrap all IconButtons and non-obvious UI elements in a Semantics widget with a clear, descriptive label for screen readers.   

Contrast: Ensure all text and UI elements meet a minimum contrast ratio of 4.5:1 against their background.   

Touch Targets: All buttons, toggles, and interactive elements must have a minimum size of 48x48dp.   

Text Scaling: The UI must be responsive and remain usable when the user increases the system font size.   

Cognitive Load: Keep the UI simple, with clear navigation and one primary action per screen.   

4. Phased Implementation Plan
This is a suggested timeline for a solo developer or small team.

Phase 1: Foundation & Core Logic (4 Weeks)

Week 1: Project setup, all dependencies added, Git repository initialized.

Week 2-3: Implement the secure database architecture. Create a DatabaseHelper class that handles key generation/retrieval (flutter_secure_storage) and database initialization/encryption (sqflite_sqlcipher). Define all data models.

Week 4: Build the main timeline UI and the forms for adding/editing basic log entries (text-based only).

Phase 2: Feature Expansion (4 Weeks)

Week 5-6: Implement the "Doctor's Report" PDF generation and sharing functionality.

Week 7: Add the photo journal feature, including image capture/selection and storage.

Week 8: Implement the full data export to CSV feature.

Phase 3: Polish & Testing (3 Weeks)

Week 9-10: Conduct a full accessibility audit. Implement all necessary Semantics, check contrast ratios, and test with TalkBack and VoiceOver.

Week 11: UI/UX refinement, adding animations, and ensuring a smooth user flow. Implement the optional biometric app lock.

Phase 4: Deployment (2 Weeks)

Week 12: Write the plain-language privacy policy. Prepare App Store and Google Play Store listings.

Week 13: Final round of testing on physical devices. Beta test with a small group of target users if possible. Submit for review.

5. Privacy Policy Requirements
Even though the app does not collect user data, a privacy policy is required by the app stores. The policy must be easily accessible within the app and on the store listing.   

Key points to include:

Explicit Statement: "CareJournal does not collect, store, transmit, or share any of your personal health information. All data you enter is stored exclusively on your own device."

Data Storage Explanation: "Your data is saved in a database on your phone that is protected with strong, industry-standard AES-256 encryption."

Data Ownership: "You are the sole owner of your data. CareJournal provides tools for you to export or delete your data at any time."

Contact Information: Provide an email address for any privacy-related questions.   


Sources and related content
