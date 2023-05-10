import * as React from 'react'
import Box from '@mui/material/Box'
import Grid from '@mui/material/Grid'
import { Typography } from '@mui/material'
import { format } from 'date-fns'
import axios from 'axios'

const Home = () => {

  const date = new Date()
  const [ip, setIp] = React.useState('')

  React.useEffect(() => {
    axios.get('https://geolocation-db.com/json/')
      .then((res) => {
        setIp(res.data.IPv4)
      })
      .catch((err) => {
        console.log(err)
      })
  }, [])

  return (
    <Box sx={{ flexGrow: 1, mt: 5 }}>
      <Grid container spacing={2}>
        <Grid item xs={12}>
          <Typography
            sx={{ textAlign: 'center', fontSize: '1rem', fontWeight: 'bold' }}
          >
            {format(date, 'PPPP')}
          </Typography>
          <Typography
            sx={{ textAlign: 'center', fontSize: '2.8rem', fontWeight: 'bold' }}
          >
            Welcome back! The IP address is {ip}
          </Typography>
        </Grid>
      </Grid>
    </Box>
  )
}
export default Home