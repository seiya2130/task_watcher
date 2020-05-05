import axios from 'axios'

const http = axios.create({
    headers: {
        common: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
    }
})

export default http