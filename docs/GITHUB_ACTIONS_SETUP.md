# GitHub Actions Setup for White Label App

This document explains how to set up GitHub Actions for automated deployment of your white label Flutter app using Fastlane.

## Workflows Overview

### 1. `build-and-test.yml`
- **Trigger**: Push to main/develop, PRs to main
- **Purpose**: Run tests and build verification for all brands
- **Matrix**: Tests all brand configurations (default, brand_a, brand_b)

### 2. `deploy-ios.yml`
- **Trigger**: Push to main/develop, manual dispatch
- **Purpose**: Deploy iOS apps for selected brands
- **Matrix**: Deploys multiple brands in parallel

### 3. `deploy-android.yml`
- **Trigger**: Push to main/develop, manual dispatch
- **Purpose**: Deploy Android apps for selected brands
- **Matrix**: Deploys multiple brands in parallel

### 4. `manual-deploy.yml`
- **Trigger**: Manual workflow dispatch only
- **Purpose**: Deploy specific brand to specific platform
- **Options**: Choose brand, platform, build mode, and store deployment

## Required GitHub Secrets

### iOS Deployment Secrets

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `IOS_CERTIFICATE_BASE64` | Base64 encoded iOS distribution certificate (.p12) | Export from Keychain, encode with `base64 -i certificate.p12` |
| `IOS_CERTIFICATE_PASSWORD` | Password for the iOS certificate | Password used when exporting certificate |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64 encoded provisioning profile | Download from Apple Developer, encode with `base64 -i profile.mobileprovision` |
| `KEYCHAIN_PASSWORD` | Password for temporary keychain | Any secure password (e.g., generated UUID) |
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | App-specific password for Apple ID | Generate at appleid.apple.com |
| `FASTLANE_SESSION` | Fastlane session token | Run `fastlane spaceauth -u your@email.com` |
| `FASTLANE_USER` | Apple ID email | Your Apple Developer account email |
| `MATCH_PASSWORD` | Password for match certificates | Only if using Fastlane Match |

### Android Deployment Secrets

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `ANDROID_KEYSTORE_BASE64` | Base64 encoded Android keystore (.jks) | Encode with `base64 -i keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | Password used when creating keystore |
| `ANDROID_KEY_ALIAS` | Key alias in keystore | Alias used when creating key |
| `ANDROID_KEY_PASSWORD` | Key password | Password for the specific key |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Google Play Console service account JSON | Create in Google Play Console → API access |

## Setup Instructions

### 1. Add Secrets to GitHub Repository

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret from the tables above

### 2. iOS Setup

```bash
# Generate iOS certificate (on macOS)
# 1. Open Keychain Access
# 2. Request certificate from Certificate Authority
# 3. Upload to Apple Developer Portal
# 4. Download and install distribution certificate
# 5. Export as .p12 file with password

# Encode certificate
base64 -i ios_distribution.p12 | pbcopy

# Encode provisioning profile
base64 -i YourApp.mobileprovision | pbcopy
```

### 3. Android Setup

```bash
# Generate Android keystore
keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias your-key-alias

# Encode keystore
base64 -i keystore.jks | pbcopy
```

### 4. Google Play Console Setup

1. Go to Google Play Console
2. Navigate to **API access**
3. Create new service account or use existing
4. Download JSON key file
5. Copy JSON content to `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` secret

## Usage

### Automatic Deployment

Deployments trigger automatically on:
- Push to `main` branch (production)
- Push to `develop` branch (staging)

### Manual Deployment

1. Go to **Actions** tab in GitHub
2. Select **Manual Brand Deployment**
3. Click **Run workflow**
4. Choose:
   - Brand ID (default, brand_a, brand_b)
   - Platform (iOS, Android, both)
   - Build mode (debug, release)
   - Deploy to store (true/false)

### Brand-Specific Deployment

Deploy all brands:
```yaml
# Automatically deploys default, brand_a, and brand_b
brand_id: all
```

Deploy specific brand:
```yaml
brand_id: brand_a
```

## Workflow Matrix Strategy

The workflows use GitHub Actions matrix strategy to deploy multiple brands in parallel:

```yaml
strategy:
  matrix:
    brand_id: [default, brand_a, brand_b]
```

This creates separate jobs for each brand, allowing parallel execution and independent success/failure status.

## Artifacts

Each workflow uploads build artifacts:
- **iOS**: `.app` and `.ipa` files
- **Android**: `.apk` and `.aab` files
- **Retention**: 30 days for releases, 7 days for tests

## Monitoring

### Success Indicators
- ✅ All matrix jobs complete successfully
- ✅ Artifacts uploaded
- ✅ Brand-specific notifications

### Failure Handling
- ❌ Individual brand failures don't stop other brands
- ❌ Detailed logs for debugging
- ❌ Artifact upload even on failure (when possible)

## Fastlane Integration

The workflows call Fastlane lanes:

```bash
# iOS deployment
fastlane ios build_and_deploy brand_id:brand_a build_mode:release

# Android deployment
fastlane android build_and_deploy brand_id:brand_a build_mode:release
```

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Use environment-specific secrets** for different deployment targets
3. **Rotate secrets regularly**, especially API keys
4. **Limit secret access** to necessary workflows only
5. **Use least privilege** for service accounts

## Troubleshooting

### Common Issues

1. **iOS Certificate Issues**
   - Ensure certificate is valid and not expired
   - Check provisioning profile matches bundle ID
   - Verify keychain password is correct

2. **Android Signing Issues**
   - Verify keystore password and key alias
   - Check key.properties file generation
   - Ensure keystore file is properly decoded

3. **Fastlane Issues**
   - Check Ruby version compatibility
   - Verify Gemfile.lock is up to date
   - Ensure service account has proper permissions

### Debug Steps

1. Check workflow logs in GitHub Actions
2. Verify secrets are properly set
3. Test Fastlane commands locally
4. Validate brand configurations exist

## Adding New Brands

To add a new brand to CI/CD:

1. Create brand configuration in `assets/brands/new_brand/`
2. Update workflow matrix in all `.yml` files:
   ```yaml
   brand_id: [default, brand_a, brand_b, new_brand]
   ```
3. Test with manual deployment first
4. Commit changes to trigger automatic deployment
