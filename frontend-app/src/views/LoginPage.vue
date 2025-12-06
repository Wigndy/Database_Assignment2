<template>
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-5">
        <div class="card p-4 shadow border-0">
          <h3 class="text-center text-primary mb-4 fw-bold">Đăng Nhập Hệ Thống</h3>
          
          <div v-if="error" class="alert alert-danger py-2">{{ error }}</div>

          <form @submit.prevent="handleLogin">
            <div class="mb-3">
              <label class="form-label fw-bold">Email</label>
              <input v-model="email" type="email" class="form-control" placeholder="Nhập email..." required>
            </div>

            <div class="mb-4">
              <label class="form-label fw-bold">Mật khẩu</label>
              <input v-model="password" type="password" class="form-control" placeholder="Nhập mật khẩu...">
              <div class="form-text small text-muted">
                <i class="bi bi-info-circle"></i> User thường: Không cần mật khẩu.<br>
                <i class="bi bi-shield-lock"></i> <b>sManager</b>: Pass là <code>admin123</code>
              </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 fw-bold py-2">
              Đăng nhập
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios'; // Đảm bảo đã import axios

const email = ref('');
const password = ref('');
const error = ref('');

const handleLogin = async () => {
  try {
    error.value = '';
    // Gọi API Backend vừa tạo
    const res = await axios.post('http://localhost:5000/api/auth/login', {
      email: email.value,
      password: password.value
    });

    if (res.data.success) {
      // Lưu thông tin user và chuyển trang
      localStorage.setItem('user', JSON.stringify(res.data.user));
      window.location.href = '/'; 
    }
  } catch (err) {
    if (err.response) {
        error.value = err.response.data.message;
    } else {
        error.value = "Lỗi kết nối đến server.";
    }
  }
};
</script>