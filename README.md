# Real-time Brute-Force Detection with Feldera and Redpanda

This project demonstrates a real-time brute-force detection pipeline using Feldera and Redpanda.  For a complete explanation, including the code and detailed analysis, see my blog post: [here](https://codecookcash.substack.com/p/detecting-brute-force-attacks-in)

## Quick Start

1. **Prerequisites:** Docker and Docker Compose.

2. **Clone and Run:**

```bash
git clone https://github.com/hoaihuongbk/feldera-experience
cd feldera-experience
make setup
```

3. **Access Feldera**: Open your browser to http://localhost:8090.

4. **Next Steps**: Refer to the blog post for instructions on creating the data stream, detection logic, and Redpanda output, as well as how to observe the results.

5. **Cleanup**: To stop the pipeline and remove containers
```bash
make clean
```