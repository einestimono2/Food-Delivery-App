const nodeMailer = require("nodemailer");

const sendEmail = async (options) => {
  const transporter = nodeMailer.createTransport({
    host: process.env.SMPT_HOST,
    port: process.env.SMPT_PORT,
    service: process.env.SMPT_SERVICE,
    secure: true,
    auth: {
      user: process.env.SMPT_MAIL,
      pass: process.env.SMPT_PASSWORD,
    },
  });

  const mailOptions = {
    from: process.env.SMPT_MAIL,
    to: options.email,
    subject: options.subject,
    html: `
            <div style="font-family: Helvetica,Arial,sans-serif; max-width: 700px; margin:auto; border: 8px solid #ddd; padding: 30px 20px;">
              <center>          
                <p style="font-size:1.8em; width: 500px; text-align: center; border-bottom:3px solid #eee; text-transform: uppercase; color: teal; font-weight: bold">${options.title}</p>
              </center>  

              <p style="margin: 40px auto 30px auto; font-size:1.1em;">Hi ${options.name},</p>
            
              <p style="margin-bottom: 15px; font-size:1em;">
                ${options.content}
              </p>
            
              <center>
                <h2 style="background: #00466a;margin: 0 auto;width: max-content;padding: 10px 22px;color: #fff;border-radius: 8px;">${options.otp}</h2>
              </center>

              <p style="margin-top: 50px; font-size:1.1em;">Regards, <br/>Food Delivery Team</p>
            </div>
        `,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = sendEmail;
