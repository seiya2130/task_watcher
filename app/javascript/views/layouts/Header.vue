<template>
<header class="py-3 bg-header">
    <div class="container d-flex justify-content-between">
        <div>
            <div>
                <router-link to="/" active-class="header-text text-white">TaskWatch</router-link>
            </div>
        </div>
        <div class="d-flex">
            <!-- <% if logged_in? %>
                <div class="mx-3">
                    <%= link_to "#{@current_user.name}", user_path(@current_user), class: "text-white" %> 
                </div>
                <div class="mx-3">
                    <%= link_to "進行中タスク一覧", tasks_progress_path, class: "text-white" %> 
                </div>
                <div class="mx-3">
                    <%= link_to "タスクリスト一覧", task_lists_path, class: "text-white" %> 
                </div>
                <div class="mx-3">
                    <%= link_to "ログアウト", logout_path, class:"text-white", method: 'delete' %>
                </div>
            <% else %>
                <div class="mx-3">
                    <%= link_to "ログイン", login_path, class:"text-white" %>
                </div>
                <div class="mx-3">
                    <%= link_to "新規登録", signup_path, class:"text-white" %>
                </div>
            <% end %> -->
            <div class="mx-3">
                <router-link to="/login" class="text-white">ログイン</router-link>
            </div>
            <div class="mx-3">
                <router-link to="/signup" class="text-white">新規登録</router-link>
            </div>
        </div>
    </div>
</header>
</template>

<script>
export default {
    
}
</script>