import axios from 'axios'
import { csrfToken } from '@rails/ujs';

const http = axios.create({
    headers: {
        common: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-TOKEN': csrfToken()
        }
    },
})


export default http