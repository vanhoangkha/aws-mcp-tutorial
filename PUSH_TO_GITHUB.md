# Hướng dẫn Push lên GitHub

## Bước 1: Tạo Repository trên GitHub

### 1.1. Mở GitHub trong trình duyệt

Truy cập: **https://github.com/new**

Hoặc:
1. Đăng nhập vào GitHub: https://github.com
2. Click vào nút **"+"** ở góc trên bên phải
3. Chọn **"New repository"**

### 1.2. Điền thông tin Repository

```
Repository name: aws-mcp-tutorial

Description:
Comprehensive guide for AWS MCP Servers - Installation, usage, and best practices for integrating AWS services with Claude Code

Visibility: ○ Public ● (chọn Public)

QUAN TRỌNG: KHÔNG chọn các option sau:
□ Add a README file (KHÔNG check)
□ Add .gitignore (KHÔNG check)
□ Choose a license (KHÔNG check)

Lý do: Repository local đã có sẵn các file này
```

### 1.3. Click "Create repository"

Sau khi click, bạn sẽ thấy trang với hướng dẫn. **Bỏ qua** phần đó và làm theo hướng dẫn bên dưới.

---

## Bước 2: Copy Commands để Push

### 2.1. Lấy GitHub username

Kiểm tra username GitHub của bạn tại: https://github.com/settings/profile

Ví dụ: Nếu profile URL là `https://github.com/johndoe`, username là `johndoe`

### 2.2. Chạy commands sau

**Thay YOUR_USERNAME bằng GitHub username thực của bạn**

```bash
# Di chuyển vào thư mục project (nếu chưa ở đó)
cd /home/ubuntu/aws-mcp-tutorial

# Add remote origin
git remote add origin https://github.com/YOUR_USERNAME/aws-mcp-tutorial.git

# Verify remote đã được add
git remote -v

# Push to GitHub
git push -u origin main
```

### 2.3. Nhập credentials

Khi được hỏi username và password:

```
Username: [your-github-username]
Password: [your-personal-access-token]
```

**Lưu ý**: GitHub không còn chấp nhận password. Bạn cần sử dụng **Personal Access Token (PAT)**

---

## Bước 3: Tạo Personal Access Token (nếu chưa có)

### 3.1. Tạo Token

1. Truy cập: https://github.com/settings/tokens
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Điền thông tin:
   ```
   Note: aws-mcp-tutorial-push
   Expiration: 30 days (hoặc tùy chọn)

   Scopes (chọn các option sau):
   repo (Full control of private repositories)
     repo:status
     repo_deployment
     public_repo
     repo:invite
   ```
4. Scroll xuống và click **"Generate token"**
5. **COPY TOKEN NGAY** (chỉ hiển thị 1 lần!)

### 3.2. Lưu Token

```bash
# Lưu token vào file an toàn (optional)
echo "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" > ~/.github-token
chmod 600 ~/.github-token

# Hoặc lưu vào biến môi trường
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

### 3.3. Push lại với Token

```bash
cd /home/ubuntu/aws-mcp-tutorial

# Push với token
git push -u origin main

# Khi được hỏi:
Username: your-username
Password: [paste token here]
```

---

## Bước 4: Verify Push thành công

### 4.1. Kiểm tra trên GitHub

Mở browser và truy cập:
```
https://github.com/YOUR_USERNAME/aws-mcp-tutorial
```

Bạn sẽ thấy:
- README.md hiển thị đẹp
- 10 files
- 2 commits
- License: MIT
- Folder structure: examples/

### 4.2. Kiểm tra bằng command

```bash
# Kiểm tra remote
git remote -v

# Output mong đợi:
origin  https://github.com/YOUR_USERNAME/aws-mcp-tutorial.git (fetch)
origin  https://github.com/YOUR_USERNAME/aws-mcp-tutorial.git (push)

# Kiểm tra branch
git branch -vv

# Output mong đợi:
* main 1a94435 [origin/main] docs: Add detailed examples...
```

---

## Bước 5: Cấu hình Git (Optional nhưng recommended)

```bash
# Set git user (để commits sau không bị warning)
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

# Amend commit cũ để update author
cd /home/ubuntu/aws-mcp-tutorial
git commit --amend --reset-author --no-edit
git push -f origin main
```

---

## Troubleshooting

### Vấn đề 1: "remote origin already exists"

```bash
# Xóa remote cũ
git remote remove origin

# Add lại
git remote add origin https://github.com/YOUR_USERNAME/aws-mcp-tutorial.git
```

### Vấn đề 2: "Authentication failed"

**Nguyên nhân**: Token sai hoặc hết hạn

**Giải pháp**:
1. Tạo token mới theo Bước 3
2. Sử dụng token thay vì password
3. Hoặc setup SSH key (xem phần dưới)

### Vấn đề 3: "Permission denied"

**Nguyên nhân**: Token không có quyền `repo`

**Giải pháp**:
1. Tạo token mới
2. Đảm bảo check repo scope
3. Copy và sử dụng token mới

### Vấn đề 4: Push chậm/timeout

```bash
# Tăng buffer size
git config --global http.postBuffer 524288000

# Retry push
git push -u origin main
```

---

## Alternative: Setup SSH Key (Recommended)

### Cách 1: Push bằng SSH thay vì HTTPS

#### 1. Generate SSH key

```bash
# Generate key
ssh-keygen -t ed25519 -C "your-email@example.com"

# Press Enter 3 times (use default location, no passphrase)

# Copy public key
cat ~/.ssh/id_ed25519.pub
```

#### 2. Add SSH key to GitHub

1. Truy cập: https://github.com/settings/keys
2. Click **"New SSH key"**
3. Title: `aws-mcp-tutorial-key`
4. Key: Paste nội dung từ `cat ~/.ssh/id_ed25519.pub`
5. Click **"Add SSH key"**

#### 3. Change remote to SSH

```bash
cd /home/ubuntu/aws-mcp-tutorial

# Remove HTTPS remote
git remote remove origin

# Add SSH remote
git remote add origin git@github.com:YOUR_USERNAME/aws-mcp-tutorial.git

# Push
git push -u origin main
```

---

## Quick Reference

```bash
# Di chuyển vào project
cd /home/ubuntu/aws-mcp-tutorial

# Kiểm tra status
git status
git log --oneline

# Add remote (HTTPS)
git remote add origin https://github.com/YOUR_USERNAME/aws-mcp-tutorial.git

# Hoặc SSH
git remote add origin git@github.com:YOUR_USERNAME/aws-mcp-tutorial.git

# Push
git push -u origin main

# Verify
git remote -v
```

---

## Next Steps sau khi Push thành công

### 1. Add Topics/Tags trên GitHub

1. Truy cập repository
2. Click (Settings icon) bên cạnh "About"
3. Add topics:
   ```
   aws, mcp, claude-code, tutorial, model-context-protocol,
   infrastructure-as-code, serverless, lambda, dynamodb, cdk
   ```

### 2. Enable GitHub Pages (Optional)

1. Settings → Pages
2. Source: Deploy from a branch
3. Branch: main, folder: / (root)
4. Save

### 3. Add Social Preview Image (Optional)

1. Settings → General
2. Social preview → Upload image
3. Recommended size: 1280x640 px

### 4. Create Release (Optional)

```bash
# Tag version
git tag -a v1.0.0 -m "Initial release: AWS MCP Tutorial"
git push origin v1.0.0

# Or via GitHub UI:
# Releases → Create a new release
```

---

**Ready!** Repository của bạn đã public và có thể share với mọi người!

Share link: `https://github.com/YOUR_USERNAME/aws-mcp-tutorial`
